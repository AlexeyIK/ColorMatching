//
//  NameQuizState.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 28.07.2021.
//

import Foundation
import SwiftUI
import Combine

class NameQuizState: ObservableObject {
    
    init() {}
    
    // constants
    private let definedTimerFrequence: Double = 0.01
    private let strikeBonusMultiplier: Int = 2
    
    // private
    private var gameScore: Int = 0
    private var quizPosition: Int = 0
    private var correctAnswers: Int = 0
    private var cancellable: AnyCancellable? = nil
    
    // public
    public var quizQuestions = 0
    public var results: QuizResults? = nil
    public var colorsViewed: [ColorModel] = []
    
    // Published
    @Published var quizItemsList: [QuizItem] = []
    @Published var quizAnswersAndScore: [QuizAnswer] = []
    @Published var quizActive: Bool = false
    @Published var lastScoreChange: Int = 0
    @Published var timerString: String = "00:00:000"
    @Published var timerStatus: TimerState = .stopped
    @Published var isAppActive: Bool = true
    
    func startQuiz(cards: [ColorModel], hardness: Hardness, russianNames: Bool, shuffled: Bool = true, runTimer: Bool = true) -> Void {
        if cards.count == 0 { return }
        
        quizPosition = 0
        correctAnswers = 0
        quizQuestions = cards.count
        
        var cardsList = cards
        // перемешиваем карточки, если надо
        if (shuffled) {
            cardsList = ShuffleCards(cardsArray: cards)
        }
        
        // создаем список вопросов заранее
        cardsList.forEach { (card) in
            var correctColor = card
            correctColor.name = GetRandomName(card.name)
            correctColor.englishName = GetRandomName(card.englishName)
            
            let colorVariants = ShuffleCards(cardsArray: SimilarColorPicker.shared.getSimilarColors(colorRef: correctColor, for: hardness, variations: 2, withRef: true, noClamp: true, isRussianOnly: russianNames))
            
            quizItemsList.append(QuizItem(answers: colorVariants, correct: correctColor))
        }
        
        // запуск таймера
        var countdown: Double = 0
        switch hardness
        {
            case .easy:
                countdown = 30
            case .normal:
                countdown  = 25
            case .hard:
                countdown  = 25
            case .hell:
                countdown  = 60
        }
        
        CoreDataManager.shared.resetLastGameScore()
        attachTimer(for: countdown, and: runTimer)
        
        self.quizActive = true
    }
    
    func attachTimer(for time: Double, and run: Bool) {
        let timer = TimerHelper.shared.setTimer(for: time, run: run)
        cancellable = timer.sink(receiveValue: { _ in
            guard self.timerStatus != .paused else { return }
            
            self.timerString = TimerHelper.shared.getRemainingTimeFomatted()
            
            self.quizAnswersAndScore.forEach { quizAnswer in
                quizAnswer.liveTimeInc(seconds: self.definedTimerFrequence)
            }
            
            if TimerHelper.shared.timeBetweenDates() <= 0 {
                self.timerStatus = .runout
                self.startGameEndPause()
            }
            else if TimerHelper.shared.timeBetweenDates() <= 5 {
                SoundPlayer.shared.playClockTiking()
            }
        })
        
        timerStatus = run ? .running : .stopped
    }
    
    func pauseTimer() {
        TimerHelper.shared.pauseTimer()
        timerStatus = .paused
    }
    
    func resumeTimer() {
        TimerHelper.shared.resumeTimer()
        timerStatus = .running
    }
    
    func startGameEndPause() {
        SoundPlayer.shared.stopClockTiking()
        
        // если время вышло, то аннулируем очки за игру
//        if timerStatus == .runout {
//            gameScore = 0
//        }

        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (Timer) in
            self.stopQuiz()
        }
    }
    
    func getQuizItem() -> QuizItem? {
        guard quizActive && quizItemsList.count > 0 else { return nil }
        return quizItemsList.first
    }
    
    func stopQuiz() -> Void  {
        guard quizActive else { return }
        
        TimerHelper.shared.cancelTimer()
        quizActive = false
        
        var strikeBonus = 0
        // начисляем бонус за страйк
        if correctAnswers == quizQuestions {
            strikeBonus = gameScore * strikeBonusMultiplier - gameScore
            CoreDataManager.shared.updatePlayerScore(by: strikeBonus)
            gameScore += strikeBonus
        }
        // записываем увиденные и разгаданные карты
        CoreDataManager.shared.addViewedColors(colorsViewed)
        // записываем результаты квиза
        NameQuizDataManager.shared.updateQuizStats(correctAnswers: correctAnswers, totalCards: quizQuestions, overallGameScore: gameScore)
        // записываем эти очки в CoreData
        CoreDataManager.shared.writeLastGameScore(gameScore)
        CoreDataManager.shared.updatePlayerScore(by: lastScoreChange)
        
        print("Quiz finished with results: [correct answers: \(correctAnswers), cards viewed: \(quizPosition), scores collected: \(gameScore)")
        
        results = QuizResults(correctAnswers: correctAnswers,
                              cardsViewed: quizPosition,
                              cardsCount: quizQuestions,
                              scoreEarned: gameScore,
                              strikeMultiplier: strikeBonusMultiplier,
                              strikeBonus: strikeBonus)
    }
    
    func checkAnswer(for quizItem: QuizItem, answer: Int = 0, hardness: Hardness) -> Bool {
        var result = false
        
        if answer > 0 && answer == quizItem.correct.id {
            correctAnswers += 1
            result = true
        }
        
        // записываем результат разгадывания цвета
        var currentColor = quizItem.correct
        currentColor.isGuessed = result
        colorsViewed.append(currentColor)
        // смотрим сколько получили очков при текущем уровне сложности
        lastScoreChange = ScoreManager.shared.getScoreByHardness(hardness, answerCorrect: result)
        gameScore += lastScoreChange
        
        quizAnswersAndScore.append(QuizAnswer(isCorrect: result, scoreEarned: lastScoreChange))
        
        if quizPosition == quizQuestions - 1 {
            TimerHelper.shared.pauseTimer()
            pauseTimer()
            startGameEndPause()
        }
        
        return result
    }
    
    func nextQuizItem() {
        if quizPosition < quizQuestions {
            quizPosition += 1
        }
    }
}

class QuizAnswer: Identifiable {
    let isCorrect: Bool
    let scoreEarned: Int
    let startOffset: CGFloat
    private(set) var lifetime: Double = 0
    
    init(isCorrect: Bool, scoreEarned: Int) {
        self.isCorrect = isCorrect
        self.scoreEarned = scoreEarned
        self.startOffset = CGFloat.random(in: -1...1)
    }
    
    func liveTimeInc(seconds: Double) {
        lifetime += seconds
    }
}

struct QuizItem: Hashable {
    let answers: [ColorModel]
    let correct: ColorModel
}

struct QuizResults {
    let correctAnswers: Int
    let cardsViewed: Int
    let cardsCount: Int
    let scoreEarned: Int
    let strikeMultiplier: Int
    let strikeBonus: Int
}
