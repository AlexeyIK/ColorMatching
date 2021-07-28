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

class LearnAndQuizState: ObservableObject  {
    
    private var savedCardsArray: [ColorModel] = []
    private var gameSessionActive: Bool = false
    
    @Published var cardsList: [ColorModel] = []
    @Published var activeGameMode: GameMode = .learn
    @Published var gameActive: Bool = false
    @Published var hardness: Hardness
    @Published var cardsCount = 7
    
    init(definedHardness: Hardness) {
        self.hardness = definedHardness
        self.cardsCount = definedHardness == .easy ? 5 : 7
        self.cardsList = startGameSession(cardsInDeck: cardsCount, with: hardness, shuffle: true)
        self.gameActive = true
    }
    
    func startGameSession(cardsInDeck numOfCards: Int, with hardness: Hardness, shuffle: Bool = false) -> [ColorModel] {
        self.hardness = hardness
        var cardsByHardness = ColorsPickerHelper.shared.getColors(byHardness: hardness)
        if shuffle {
            cardsByHardness = ShuffleCards(cardsArray: cardsByHardness)
        }
        
        savedCardsArray = GetSequentalNumOfCards(cardsArray: cardsByHardness, numberOfCards: numOfCards)
        self.cardsList = savedCardsArray
        self.gameActive = true;
        
        return savedCardsArray
    }
    
    func endGameSession() {
        self.gameActive = false
    }
}
