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
    
    var body: some View {
        ZStack {
            switch gameState.activeGameMode
            {
                case .learn:
                    LearnDeckView(cardsState: Array(repeating: CardState(), count: gameState.cardsCount))
                        .environmentObject(gameState)
                case .quiz:
                    QuizGameView(useTimer: true, showColorNames: false)
                        .environmentObject(gameState)
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
