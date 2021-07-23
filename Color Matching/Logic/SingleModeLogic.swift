//
//  SingleModeLogic.swift
//  Color Matching
//
//  Created by Alexey on 18.07.2021.
//

import Foundation
import SwiftUI

public class LearnColorsGameManager {
    
    static let shared = LearnColorsGameManager()
    
    private init() { }
    
    var gameSessionActive: Bool = false
    var savedCardsArray: [ColorModel] = []
    var currentHardness: Hardness = .easy
    var countdown: Timer = Timer()
    var quizPosition: Int = 0
    
    func StartGameSession(cardsInDeck numOfCards: Int, with hardness: Hardness, shuffle: Bool = false) -> [ColorModel] {
        currentHardness = hardness
        var cardsByHardness = ColorsPickerHelper.shared.getColors(byHardness: hardness)
        if (shuffle) {
            cardsByHardness = ShuffleCards(cardsArray: cardsByHardness)
        }
        
        savedCardsArray = GetSequentalNumOfCards(cardsArray: cardsByHardness, numberOfCards: numOfCards)
        gameSessionActive = true;
        
        return savedCardsArray
    }
    
    func EndGameSession() {
        gameSessionActive = false
    }
    
    func StartQuiz(cards: [ColorModel], timer: Double = 0, shuffled: Bool = false) {
        
        quizPosition = -1
        
        if (shuffled) {
            savedCardsArray = cards.shuffled()
        }
        
        if timer > 0 {
            countdown = Timer(timeInterval: timer, repeats: false, block: { (time) in
                // stop game
            })
        }
    }
    
    func GetNextQuizItem() -> QuizItem {
        quizPosition += 1
        let item = QuizItem(answersIds: [1, 2], correctId: savedCardsArray[quizPosition].id)
        return item
    }
    
    func CheckAnswer(quizItem: QuizItem, answer: Int = 0) -> Bool {
        if answer > 0 {
            return answer == quizItem.correctId
        }
        else {
            return false
        }
    }
    
    func StopQuiz() -> QuizResults  {
        return QuizResults()
    }
}

struct QuizItem {
    var answersIds: [Int]
    var correctId: Int
}

struct QuizResults {
    var correctAnswers = 0
    var cardsViewed = 0
}
