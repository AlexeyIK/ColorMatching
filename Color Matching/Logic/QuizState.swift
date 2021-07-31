//
//  QuizState.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 28.07.2021.
//

import Foundation
import SwiftUI

class QuizState: ObservableObject {
    
    init() {}
    
    private let definedTimerFrequence: Double = 0.01
    
    private var countdownTimer: Timer?
    private var endDateTime = Date()
    private var currentDateTime = Date()
    private var saveElapsedTime: TimeInterval = 0
    private var isTimerPaused: Bool = false
    private var colorsViewed: [ColorModel: Bool] = [:]
    
    public var quizQuestions = 0
    public var results: QuizResults? = nil
    
    @Published var quizItemsList: [QuizItem] = []
    @Published var quizAnswersAndScore: [QuizAnswer] = []
    @Published var quizActive: Bool = false
    @Published var timeRunOut: Bool = false
    @Published var quizPosition: Int = 0
    @Published var correctAnswers: Int = 0
    @Published var lastScoreChange: Int = 0
    @Published var timerString: String = "00:00:000"
    @Published var isAppActive: Bool = true
    
    func startQuiz(cards: [ColorModel], hardness: Hardness, shuffled: Bool = true) -> Void {
        if cards.count == 0 { return }
        
        var cardsList = cards
        self.quizActive = true
        quizPosition = 0
        quizQuestions = cards.count
        
        // перемешиваем карточки, если надо
        if (shuffled) {
            cardsList = ShuffleCards(cardsArray: cards)
        }
        
        // создаем лист квизов заранее
        cardsList.forEach { (card) in
            let correctColor = card
            let colorVariants = ShuffleCards(cardsArray: SimilarColorPicker.shared.getSimilarColors(colorRef: correctColor, for: hardness, withRef: true))
            quizItemsList.append(QuizItem(answers: colorVariants, correctId: correctColor.id))
        }
        
        // запуск таймера
        var countdown: Double = 0
        switch hardness
        {
            case .easy:
                countdown = 15
            case .normal:
                countdown  = 10
            case .hard:
                countdown  = 10
            case .hell:
                countdown  = 60
        }
        
        startTimer(for: countdown)
    }
    
    func startTimer(for time: Double) {
        currentDateTime = Date()
        endDateTime = Date.init(timeIntervalSinceNow: time)
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: definedTimerFrequence, repeats: true, block: { _ in
            guard !self.isTimerPaused else { return }
            
            self.currentDateTime = Date()
            self.timerString = TimerHelper.shared.getTimeIntervalFomatted(from: self.currentDateTime, until: self.endDateTime)
            
            self.quizAnswersAndScore.forEach { quizAnswer in
                quizAnswer.liveTimeInc(seconds: self.definedTimerFrequence)
            }
            
            if self.endDateTime.timeIntervalSinceReferenceDate - self.currentDateTime.timeIntervalSinceReferenceDate <= 0 {
                self.timeRunOut = true
                self.startGameEndPause()
            }
        })
    }
    
    func pauseTimer() {
        isTimerPaused = true
        saveElapsedTime = self.endDateTime.timeIntervalSinceReferenceDate - self.currentDateTime.timeIntervalSinceReferenceDate
        print("Timer paused")
    }
    
    func resumeTimer() {
        endDateTime = Date.init(timeIntervalSinceNow: saveElapsedTime)
        isTimerPaused = false
        print("Timer resumed")
    }
    
    func startGameEndPause() {
        if let timer = countdownTimer {
            timer.invalidate()
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (Timer) in
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
        
        print("Quiz finished with results: [correct answers: \(correctAnswers), cards viewed: \(quizPosition)")
//        let onlyGuessedColors = colorsGuessed.filter({ $0.value })
        CoreDataManager.shared.updateQuizScore(correctAnswers: correctAnswers, totalCards: quizQuestions, cardsViewed: colorsViewed)
        
        results = QuizResults(correctAnswers: correctAnswers,
                              cardsViewed: quizPosition,
                              cardsCount: quizQuestions)
    }
    
    func checkAnswer(for quizItem: QuizItem, answer: Int = 0, hardness: Hardness) -> Bool {
        var result = false
        
        if answer > 0 && answer == quizItem.correctId {
            correctAnswers += 1
            quizPosition += 1
            result = true
        }
        else {
            quizPosition += 1
        }
        
        // записываем результат разгадывания цвета
        colorsViewed[colorsData[quizItem.correctId]] = result
        // смотрим сколько получили очков при текущем уровне сложности
        lastScoreChange = ScoreManager.shared.getScoreByHardness(hardness, answerCorrect: result)
        // записываем эти очки в CoreData
        CoreDataManager.shared.updatePlayerScore(by: lastScoreChange)
        
        quizAnswersAndScore.append(QuizAnswer(isCorrect: result, scoreEarned: lastScoreChange))
        
        if quizPosition == quizQuestions || timeRunOut {
            stopQuiz()
        }
        
        return result
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
    let correctId: Int
}

struct QuizResults {
    let correctAnswers: Int
    let cardsViewed: Int
    let cardsCount: Int
}
