//
//  GameHelpers.swift
//  Color Matching
//
//  Created by Alexey on 20.07.2021.
//

import Foundation

func GetSequentalNumOfCards(cardsArray: [ColorModel], numberOfCards: Int = 10) -> [ColorModel] {
    
    var newCardList: [ColorModel] = []
    
    for _ in 0..<numberOfCards {
        let rndCard = cardsArray[Int.random(in: 0..<cardsArray.count)]
        newCardList.append(rndCard)
    }
    
    return newCardList
}

func ShuffleCards(cardsArray: [ColorModel]) -> [ColorModel] {
    return cardsArray.shuffled()
}
