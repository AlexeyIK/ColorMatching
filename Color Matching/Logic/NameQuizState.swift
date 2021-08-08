//
//  NameQuizState.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 28.07.2021.
//

import Foundation
import SwiftUI

class NameQuizState: ObservableObject {
    
    init() {}
    
    // constants
    private let definedTimerFrequence: Double = 0.01
    private let strikeBonusMultiplier: Int = 2
    
    // private
    private var countdownTimer: Timer?
    private var endDateTime = Date()
    private var currentDateTime = Date()
    private var saveElapsedTime: TimeInterval = 0
    private var gameScore: Int = 0
    
    private var quizPosition: Int = 0
    private var correctAnswers: Int = 0
    
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
    
    func startQuiz(cards: [ColorModel], hardness: Hardness, russianNames: Bool, shuffled: Bool = true) -> Void {
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
            let correctColor = card
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
                countdown  = 20
            case .hard:
                countdown  = 15
            case .hell:
                countdown  = 60
        }
        
        CoreDataManager.shared.resetLastGameScore()
        startTimer(for: countdown)
        
        self.quizActive = true
    }
    
    func startTimer(for time: Double) {
        currentDateTime = Date()
        endDateTime = Date.init(timeIntervalSinceNow: time)
        timerString = TimerHelper.shared.getTimeIntervalFomatted(from: self.currentDateTime, until: self.endDateTime)
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: definedTimerFrequence, repeats: true, block: { _ in
            guard self.timerStatus != .paused && self.timerStatus != .runout else { return }
            
            self.currentDateTime = Date()
            self.timerString = TimerHelper.shared.getTimeIntervalFomatted(from: self.currentDateTime, until: self.endDateTime)
            
            self.quizAnswersAndScore.forEach { quizAnswer in
                quizAnswer.liveTimeInc(seconds: self.definedTimerFrequence)
            }
            
            if self.endDateTime.timeIntervalSinceReferenceDate - self.currentDateTime.timeIntervalSinceReferenceDate <= 0 {
                self.timerStatus = .runout
                self.startGameEndPause()
            }
        })
    }
    
    func pauseTimer() {
        saveElapsedTime = self.endDateTime.timeIntervalSinceReferenceDate - self.currentDateTime.timeIntervalSinceReferenceDate
        timerStatus = .paused
        print("Timer paused")
    }
    
    func resumeTimer() {
        endDateTime = Date.init(timeIntervalSinceNow: saveElapsedTime)
        timerStatus = .running
        print("Timer resumed")
    }
    
    func startGameEndPause() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (Timer) in
            if let timer = self.countdownTimer {
                timer.invalidate()
                print("Timer deleted")
            }
            
            self.stopQuiz()
        }
    }
    
    func getQuizItem() -> QuizItem? {
        guard quizActive && quizItemsList.count > 0 else { return nil }
        
//        print("quiz position: \(quizPosition), quizItemsRemains: \(quizItemsList.count)")
        return quizItemsList.first
    }
    
    func stopQuiz() -> Void  {
        guard quizActive else { return }
        
        if let timer = countdownTimer {
            timer.invalidate()
        }
        
        quizActive = false
        
        var strikeBonus = 0
        // начисляем бонус за страйк
        if correctAnswers == quizQuestions {
            strikeBonus = gameScore * strikeBonusMultiplier - gameScore
            CoreDataManager.shared.updatePlayerScore(by: strikeBonus)
            gameScore += strikeBonus
        }
        CoreDataManager.shared.addViewedColors(colorsViewed)
        NameQuizDataManager.shared.updateQuizStats(correctAnswers: correctAnswers, totalCards: quizQuestions, overallGameScore: gameScore)
        CoreDataManager.shared.writeLastGameScore(gameScore)
        
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
        // записываем эти очки в CoreData
        CoreDataManager.shared.updatePlayerScore(by: lastScoreChange)
        
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
