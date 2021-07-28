//
//  LearnAndQuizView.swift
//  Color Matching
//
//  Created by Alexey on 24.07.2021.
//

import SwiftUI

struct LearnAndQuizView: View {
    
    @StateObject var gameState: LearnAndQuizState = LearnAndQuizState()
    
    var body: some View {
        switch gameState.activeGameMode
        {
            case .learn:
                DeckView(cardsState: Array(repeating: CardState(), count: gameState.cardsCount))
                    .environmentObject(gameState)
            case .quiz:
                QuizGameView(useTimer: true, showColorNames: false)
                    .environmentObject(gameState)
        }
    }
}

struct LearnAndQuizView_Previews: PreviewProvider {
    static var previews: some View {
        LearnAndQuizView()
    }
}
