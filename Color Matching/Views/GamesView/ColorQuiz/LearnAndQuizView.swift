//
//  LearnAndQuizView.swift
//  Color Matching
//
//  Created by Alexey on 24.07.2021.
//

import SwiftUI

struct LearnAndQuizView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var gameState: LearnAndQuizState = LearnAndQuizState()
    @StateObject var resultState: QuizResultsStore = QuizResultsStore()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            switch gameState.activeGameMode
            {
                case .prepare:
                    QuizStartView()
                        .environmentObject(gameState)
                case .learn:
                    LearnDeckView(cardsState: Array(repeating: CardState(), count: gameState.cardsCount))
                        .environmentObject(gameState)
                case .quiz:
                    QuizGameView(showColorNames: false)
                        .environmentObject(gameState)
                        .environmentObject(resultState)
                        .transition(.opacity)
                case .results:
                    QuizResultsView()
                        .environmentObject(gameState)
                        .environmentObject(resultState)
                        .transition(.opacity)
            }
        }
        .navigationBarItems(
            leading:
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(_globalNavBarButtonsColor)
                    
                    Button("Menu") {
                        gameState.endGameSession()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(BackButton())
                }
        )
    }
}

struct LearnAndQuizView_Previews: PreviewProvider {
    static var previews: some View {
        LearnAndQuizView()
    }
}
