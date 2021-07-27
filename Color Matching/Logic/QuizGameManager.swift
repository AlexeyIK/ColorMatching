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
    
    private var gameSessionActive: Bool = false
    
    var countdown: Float = 0
    var currentHardness: Hardness = .easy
    var savedCardsArray: [ColorModel] = []
    var quizItemsList: [QuizItem] = []
    
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
        
        return Timer.publish(every: 0.1, on: .main, in: .common)
    }
    
    func getQuizItem() -> QuizItem? {
        guard gameSessionActive else { return nil }
        
        return quizItemsList[quizPosition]
    }
    
    func stopQuiz(timer: Timer.TimerPublisher? = nil) -> QuizResults  {
        if let tm = timer {
            tm.connect().cancel()
        }
        return QuizResults()
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
}

struct QuizItem {
    var answers: [ColorModel]
    var correctId: Int
}

struct QuizResults {
    var correctAnswers = 0
    var cardsViewed = 0
}
