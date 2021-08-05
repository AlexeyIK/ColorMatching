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
}

// уровень сложности по умолчанию
var _definedHardness: Hardness = .easy

class LearnAndQuizState: ObservableObject  {
    
    private var savedCardsArray: [ColorModel] = []
    private var gameSessionActive: Bool = false
    
    @Published var russianNames: Bool = true
    @Published var cardsList: [ColorModel] = []
    @Published var activeGameMode: GameMode = .prepare
    @Published var gameActive: Bool = false
    @Published var hardness: Hardness
    @Published var cardsCount = 7
    
    init(definedHardness: Hardness = _definedHardness) {
        let lastHardness = CoreDataManager.shared.getLastQuizHardness()
        self.hardness = lastHardness == 0 ? definedHardness : Hardness.init(rawValue: lastHardness) ?? .easy
        self.cardsCount = getDefaultNumOfCards(for: definedHardness)
    }
    
    func startGameSession(shuffle: Bool = false) {
        let cardsByHardness = ColorsPickerHelper.shared.getColors(byHardness: hardness, shuffle: shuffle).filter({ russianNames ? $0.name != "" : $0.englishName != "" })
        
        savedCardsArray = GetSequentalNumOfCards(cardsArray: cardsByHardness, numberOfCards: cardsCount)
        self.cardsList = savedCardsArray
        self.activeGameMode = .learn
        self.gameActive = true;
        
        CoreDataManager.shared.writeCurrentHardness(hardness)
    }
    
    func endGameSession() {
        self.gameActive = false
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
