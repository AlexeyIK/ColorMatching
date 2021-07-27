//
//  LearnAndQuizView.swift
//  Color Matching
//
//  Created by Alexey on 24.07.2021.
//

import SwiftUI

//fileprivate let _definedHardness: Hardness = .hard
//fileprivate let _cardsCount: Int = _definedHardness == .easy ? 5 : 7

enum GameMode {
    case learn
    case quiz
}

class LearnAndQuizState: ObservableObject  {
    @Published var cardsList: [ColorModel] = []
    @Published var activeGameMode: GameMode = .learn
    @Published var gameActive: Bool = false
    @Published var timeRunOut: Bool = false
    @Published var hardness: Hardness
    @Published var cardsCount = 7
    
    init(definedHardness: Hardness) {
        self.hardness = definedHardness
        self.cardsCount = definedHardness == .easy ? 5 : 7
        self.cardsList = QuizGameManager.shared.startGameSession(cardsInDeck: cardsCount, with: hardness, shuffle: true)
        self.gameActive = true
    }
}

struct LearnAndQuizView: View {
    
    @StateObject var gameState: LearnAndQuizState = LearnAndQuizState(definedHardness: .easy)
    
    var body: some View {
        
        switch gameState.activeGameMode
        {
            case .learn:
                DeckView(cardsList: gameState.cardsList, cardsState: Array(repeating: CardState(), count: gameState.cardsCount))
                    .environmentObject(gameState)
            case .quiz:
                QuizGameView(hardnessLvl: gameState.hardness, showColorNames: false, useTimer: true)
                    .environmentObject(gameState)
        }
    }
}

struct LearnAndQuizView_Previews: PreviewProvider {
    static var previews: some View {
        LearnAndQuizView()
    }
}
