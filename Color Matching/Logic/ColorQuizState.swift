//
//  ColorQuizState.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 07.08.2021.
//

import Foundation
import SwiftUI
import Combine

class ColorQuizState: ObservableObject {
    
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
    @Published var timerStatus: TimerState = .stopped
    @Published var timerString: String = "00:00:000"
    @Published var isAppActive: Bool = true
    
    func startQuiz(cards: [ColorModel], hardness: Hardness, russianNames: Bool, shuffled: Bool = true, runTimer: Bool) -> Void {
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
        createQuizItems(availableCards: cardsList, hardness: hardness, russianNames: russianNames)
        
        var countdown: Double = 0
        // запуск таймера на указанное время от уровня сложности
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
        attachTimer(for: countdown, run: runTimer)
        
        self.quizActive = true
    }
    
    func createQuizItems(availableCards: [ColorModel], hardness: Hardness, russianNames: Bool) {
        
        var variationsNum = 2
        
        // определяем сколько нам надо вариаций цветов для одного задания
        switch hardness {
        case .easy:
            variationsNum = 2
        case .normal:
            variationsNum = 3
        case .hard:
            variationsNum = 4
        case .hell:
            variationsNum = 4
        }
        
        availableCards.forEach { (card) in
            let correctColor = card
            let colorVariants = ShuffleCards(cardsArray: SimilarColorPicker.shared.getSimilarColors(colorRef: correctColor, for: hardness, variations: variationsNum, withRef: true, noClamp: true, isRussianOnly: russianNames, useTrueColors: true))
            quizItemsList.append(QuizItem(answers: colorVariants, correct: correctColor))
        }
    }
    
    func attachTimer(for time: Double, run: Bool = true) {
        let timer = TimerHelper.shared.setTimer(for: time, run: run)
        cancellable = timer.eraseToAnyPublisher().sink(receiveValue: { _ in
            self.makeScoresFly()
            guard self.timerStatus != .paused && self.timerStatus != .runout else { return }
            
            self.timerString = TimerHelper.shared.getRemainingTimeFomatted()
            
            if TimerHelper.shared.timeBetweenDates() <= 0 {
                SoundPlayer.shared.stopClockTiking()
                self.timerStatus = .runout
                self.startGameEndPause()
            }
            else if TimerHelper.shared.timeBetweenDates() <= 5 {
                SoundPlayer.shared.playClockTiking()
            }
        })
        
        timerStatus = run ? .running : .stopped
    }
    
    func runTimer() {
        timerStatus = .running
    }
    
    func pauseTimer() {
        TimerHelper.shared.pauseTimer()
        timerStatus = .paused
    }
    
    func resumeTimer() {
        TimerHelper.shared.resumeTimer()
        timerStatus = .running
    }
    
    func makeScoresFly() {
        self.quizAnswersAndScore.forEach { quizAnswer in
            quizAnswer.liveTimeInc(seconds: self.definedTimerFrequence)
        }
    }
    
    func startGameEndPause() {
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
        // записываем увиденные и разгаданные цвета
        CoreDataManager.shared.addViewedColors(colorsViewed)
        // записываем результаты квиза
        ColorQuizDataManager.shared.updateQuizStats(correctAnswers: correctAnswers, totalCards: quizQuestions, overallGameScore: gameScore)
        // записываем эти очки в CoreData
        CoreDataManager.shared.writeLastGameScore(gameScore)
        CoreDataManager.shared.updatePlayerScore(by: gameScore)
        
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
        let lastScoreChange = ScoreManager.shared.getScoreByHardness(hardness, answerCorrect: result)
        gameScore += lastScoreChange
        
        quizAnswersAndScore.append(QuizAnswer(isCorrect: result, scoreEarned: lastScoreChange))
        
        if quizPosition == quizQuestions - 1 {
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
