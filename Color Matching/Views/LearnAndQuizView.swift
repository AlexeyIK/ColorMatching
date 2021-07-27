//
//  LearnAndQuizView.swift
//  Color Matching
//
//  Created by Alexey on 24.07.2021.
//

import SwiftUI

//fileprivate let _definedHardness: Hardness = .hard
//fileprivate let _cardsCount: Int = _definedHardness == .easy ? 5 : 7

class LearnAndQuizState: ObservableObject  {
    @Published var cardsList: [ColorModel] = []
    @Published var quizModeOn = false
    @Published var timeRunOut = false
    @Published var hardness: Hardness
    @Published var cardsCount = 7
    
    init(definedHardness: Hardness) {
        self.hardness = definedHardness
        self.cardsCount = definedHardness == .easy ? 5 : 7
        self.cardsList = QuizGameManager.shared.startGameSession(cardsInDeck: cardsCount, with: hardness, shuffle: true)
    }
}

struct LearnAndQuizView: View {
    
    @StateObject var gameState: LearnAndQuizState = LearnAndQuizState(definedHardness: .easy)
    
    var body: some View {
        if gameState.quizModeOn {
            QuizGameView(hardnessLvl: gameState.hardness, showColorNames: false, useTimer: true)
                .environmentObject(gameState)
        } else {
            DeckView(cardsList: gameState.cardsList, cardsState: Array(repeating: CardState(), count: gameState.cardsCount))
                .environmentObject(gameState)
        }
    }
}

struct LearnAndQuizView_Previews: PreviewProvider {
    static var previews: some View {
        LearnAndQuizView()
    }
}
