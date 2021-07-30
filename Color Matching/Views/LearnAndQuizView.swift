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
                    Button("< to menu") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.body)
                    .foregroundColor(Color.init(hue: 0, saturation: 0, brightness: 0.34, opacity: 1))
                }
        )
    }
}

struct LearnAndQuizView_Previews: PreviewProvider {
    static var previews: some View {
        LearnAndQuizView()
    }
}
