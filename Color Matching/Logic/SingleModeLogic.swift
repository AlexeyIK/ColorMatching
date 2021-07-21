//
//  SingleModeLogic.swift
//  Color Matching
//
//  Created by Alexey on 18.07.2021.
//

import Foundation

public class LearnColorsGameManager {
    
    static let shared = LearnColorsGameManager()
    
    private init() { }
    
    var savedCardsArray: [ColorModel] = []
    
    func StartGame(cardsInDeck numOfCards: Int) -> [ColorModel] {
        savedCardsArray = GetSequentalNumOfCards(cardsArray: colorsData, numberOfCards: numOfCards)
        
        return savedCardsArray
    }
}

