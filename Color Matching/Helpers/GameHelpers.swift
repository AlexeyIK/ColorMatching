//
//  GameHelpers.swift
//  Color Matching
//
//  Created by Alexey on 20.07.2021.
//

import Foundation

func GetSequentalNumOfCards(cardsArray: [ColorModel], numberOfCards: Int = 10) -> [ColorModel] {
    
    let rndStart = Int.random(in: 0..<cardsArray.count - numberOfCards)
    let newCardList = Array(cardsArray[rndStart..<rndStart + numberOfCards])
    
    return newCardList
}

func ShuffleCards(cardsArray: [ColorModel]) -> [ColorModel] {
    return cardsArray.shuffled()
}
