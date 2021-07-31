//
//  LearnAndQuizState.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 29.07.2021.
//

import Foundation
import SwiftUI

enum GameMode {
    case learn
    case quiz
}

var _definedHardness: Hardness = .normal

class LearnAndQuizState: ObservableObject  {
    
    private var savedCardsArray: [ColorModel] = []
    private var gameSessionActive: Bool = false
    
    @Published var cardsList: [ColorModel] = []
    @Published var activeGameMode: GameMode = .learn
    @Published var gameActive: Bool = false
    @Published var hardness: Hardness
    @Published var cardsCount = 7
    
    init(definedHardness: Hardness = _definedHardness) {
        self.hardness = definedHardness
        self.cardsCount = getDefaultNumOfCards(for: definedHardness)
        startGameSession(cardsInDeck: cardsCount, with: hardness, shuffle: true)
    }
    
    func startGameSession(cardsInDeck numOfCards: Int, with hardness: Hardness, shuffle: Bool = false) {
        self.hardness = hardness
        self.cardsCount = numOfCards
        
        var cardsByHardness = ColorsPickerHelper.shared.getColors(byHardness: hardness)
        if shuffle {
            cardsByHardness = ShuffleCards(cardsArray: cardsByHardness)
        }
        
        savedCardsArray = GetSequentalNumOfCards(cardsArray: cardsByHardness, numberOfCards: numOfCards)
        self.cardsList = savedCardsArray
        self.gameActive = true;
    }
    
    func endGameSession() {
        self.gameActive = false
        self.activeGameMode = .learn
    }
    
    func restartGameSession() {
        endGameSession()
        activeGameMode = .learn
        startGameSession(cardsInDeck: getDefaultNumOfCards(for: hardness), with: _definedHardness)
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
