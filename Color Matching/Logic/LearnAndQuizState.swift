//
//  LearnAndQuizState.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 29.07.2021.
//

import Foundation
import SwiftUI

enum GameMode {
    case prepare
    case learn
    case quiz
    case results
}

enum QuizType {
    case nameQuiz
    case colorQuiz
}

// уровень сложности по умолчанию
var _definedHardness: Hardness = .easy

class LearnAndQuizState: ObservableObject  {
    
    private var savedCardsArray: [ColorModel] = []
    private var gameSessionActive: Bool = false
    private var quizType: QuizType = .nameQuiz
    
    @Published var russianNames: Bool = true
    @Published var cardsList: [ColorModel] = []
    @Published var activeGameMode: GameMode = .prepare
    @Published var gameActive: Bool = false
    @Published var hardness: Hardness
    @Published var cardsCount = 7
    
    init(quizType: QuizType, definedHardness: Hardness = _definedHardness) {
        self.quizType = quizType
        
        var lastHardness = 0
        
        switch quizType {
            case .nameQuiz:
                lastHardness = NameQuizDataManager.shared.getPreviousHardness()
            case .colorQuiz:
                lastHardness = ColorQuizDataManager.shared.getPreviousHardness()
        }
        
        self.hardness = lastHardness == 0 ? definedHardness : Hardness.init(rawValue: lastHardness) ?? .easy
        
        self.russianNames = Locale.current.languageCode == "ru"
    }
    
    func startGameSession(shuffle: Bool = false) {
        let cardsByHardness = ColorsPickerHelper.shared.getColors(byHardness: hardness, shuffle: shuffle).filter({ russianNames ? $0.name != "" : $0.englishName != "" })
        
        self.cardsCount = getDefaultNumOfCards(for: hardness)
        
        savedCardsArray = GetSequentalNumOfCards(cardsArray: cardsByHardness, numberOfCards: cardsCount)
        self.cardsList = savedCardsArray
        self.activeGameMode = .learn
        self.gameActive = true;
        
        switch quizType {
            case .nameQuiz:
                NameQuizDataManager.shared.writeCurrentHardness(hardness)
            case .colorQuiz:
                ColorQuizDataManager.shared.writeCurrentHardness(hardness)
        }
    }
    
    func endGameSession() {
        self.gameActive = false
        TimerHelper.shared.cancelTimer()
    }
    
    func restartGameSession() {
        endGameSession()
        activeGameMode = .learn
        startGameSession()
    }
    
    func getDefaultNumOfCards(for hardness: Hardness) -> Int {
        switch hardness {
            case .easy:
                return 5
            case .normal:
                return 7
            case .hard:
                return 7
            case .hell:
                return 9
        }
    }
}
