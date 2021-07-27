//
//  QuizGameManager.swift
//  Color Matching
//
//  Created by Alexey on 18.07.2021.
//

import Foundation
import SwiftUI

public class QuizGameManager {
    
    static let shared = QuizGameManager()
    
    private init() { }
    
    private var countdownTimer: Timer.TimerPublisher? = nil
    private var endDateTime = Date()
    private var currentDateTime = Date()
    
    var countdown: Double = 0
    var currentHardness: Hardness = .easy
    var savedCardsArray: [ColorModel] = []
    var quizItemsList: [QuizItem] = []
    
    public var gameSessionActive: Bool = false
    public var quizPosition: Int = 0
    public var correctAnswers: Int = 0
    
    func startGameSession(cardsInDeck numOfCards: Int, with hardness: Hardness, countdown timer: Bool = false, shuffle: Bool = false) -> [ColorModel] {
        currentHardness = hardness
        var cardsByHardness = ColorsPickerHelper.shared.getColors(byHardness: hardness)
        
        if shuffle {
            cardsByHardness = ShuffleCards(cardsArray: cardsByHardness)
        }
        
        savedCardsArray = GetSequentalNumOfCards(cardsArray: cardsByHardness, numberOfCards: numOfCards)
        gameSessionActive = true;
        
        return savedCardsArray
    }
    
    func endGameSession() {
        gameSessionActive = false
    }
    
    func startQuiz(cards: [ColorModel], shuffled: Bool) -> [ColorModel] {
        guard gameSessionActive else { return [] }
        
        quizPosition = 0
        
        // перемешиваем карточки, если надо
        if (shuffled) {
            savedCardsArray = ShuffleCards(cardsArray: cards)
        }
        
        // создаем лист квизов заранее
        savedCardsArray.forEach { (card) in
            let correctColor = card
            let colorVariants = ShuffleCards(cardsArray: SimilarColorPicker.shared.getSimilarColors(colorRef: correctColor, for: currentHardness, withRef: true))
            quizItemsList.append(QuizItem(answers: colorVariants, correctId: correctColor.id))
        }
        
        return savedCardsArray
    }
    
    func startTimer() -> Timer.TimerPublisher {
        switch currentHardness
        {
            case .easy:
                countdown = 120
            case .normal:
                countdown  = 90
            case .hard:
                countdown  = 90
            case .hell:
                countdown  = 60
        }
        
        currentDateTime = Date()
        endDateTime = Date.init(timeIntervalSinceNow: countdown)
        countdownTimer = Timer.publish(every: 0.02, on: .main, in: .common)
        
        return countdownTimer!
    }
    
    func getRemainingTime() -> (time: String, active: Bool) {
        currentDateTime = Date()
        
        let timeRemainsStr = countDownString(from: endDateTime, until: currentDateTime)
        if endDateTime.timeIntervalSinceReferenceDate - currentDateTime.timeIntervalSinceReferenceDate > 0 {
            return (timeRemainsStr, true)
        }
        else {
            return ("00:00:000", false)
        }
    }
    
    func getQuizItem() -> QuizItem? {
        guard gameSessionActive else { return nil }
        
        return quizItemsList[quizPosition]
    }
    
    func stopQuiz() -> QuizResults  {
        if let timer = countdownTimer {
            timer.connect().cancel()
        }
        
        print("Quiz finished with results: [correct answers: \(correctAnswers), cards viewed: \(quizPosition)")
        
        return QuizResults(correctAnswers: correctAnswers, cardsViewed: quizPosition, cardsCount: quizItemsList.count, allCorrect: correctAnswers == quizItemsList.count)
    }
    
    func checkAnswer(for quizItem: QuizItem, answer: Int = 0) -> Bool {
        if answer > 0 && answer == quizItem.correctId {
            correctAnswers += 1
            quizPosition += 1
            return true
        }
        else {
            quizPosition += 1
            return false
        }
    }
    
    func countDownString(from date: Date, until nowDate: Date) -> String {
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.minute, .second, .nanosecond], from: nowDate, to: date)
            return String(format: "%02d:%02d:%03d",
                          components.minute ?? 00,
                          components.second ?? 00,
                          (components.nanosecond ?? 000) / 1000000)
    }
}

struct QuizItem {
    let answers: [ColorModel]
    let correctId: Int
}

struct QuizResults {
    let correctAnswers: Int
    let cardsViewed: Int
    let cardsCount: Int
    let allCorrect: Bool
}
