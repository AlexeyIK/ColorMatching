//
//  LearnAndQuizView.swift
//  Color Matching
//
//  Created by Alexey on 24.07.2021.
//

import SwiftUI

fileprivate let _definedHardness: Hardness = .hard
fileprivate let _cardsCount: Int = _definedHardness == .easy ? 5 : 7

class LearnAndQuizState: ObservableObject  {
    @Published var quizModeOn = false
    @Published var hardness: Hardness = _definedHardness
    @Published var cardsCount = 7
}

struct LearnAndQuizView: View {
    
    @StateObject var gameState: LearnAndQuizState = LearnAndQuizState()
    @State var cardsList = LearnColorsGameManager.shared.StartGameSession(cardsInDeck: _cardsCount, with: _definedHardness, shuffle: true)
    
    var body: some View {
        if gameState.quizModeOn {
            QuizGameView(hardnessLvl: _definedHardness, showColorName: false, cardsList: cardsList, currentQuizStep: 0, correctAnswers: 0)
                .environmentObject(gameState)
        } else {
            DeckView(cardsList: cardsList, cardsState: Array(repeating: CardState(), count: _cardsCount))
                .environmentObject(gameState)
        }
    }
}

struct LearnAndQuizView_Previews: PreviewProvider {
    static var previews: some View {
        LearnAndQuizView()
    }
}
