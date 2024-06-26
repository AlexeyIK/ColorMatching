//
//  ColorQuizMainView.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 05.08.2021.
//

import SwiftUI

struct ColorQuizMainView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        
    @EnvironmentObject var settingsState: SettingsState
    @EnvironmentObject var menuState: MenuState
    
    @StateObject var gameState: LearnAndQuizState = LearnAndQuizState(quizType: .colorQuiz)
    @StateObject var resultState: QuizResultsStore = QuizResultsStore()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            switch gameState.activeGameMode
            {
                case .prepare:
                    ColorQuizStartView()
                        .environmentObject(gameState)
                        .environmentObject(settingsState)
                case .learn:
                    LearnDeckView(cardsState: Array(repeating: CardState(), count: gameState.cardsCount))
                        .environmentObject(gameState)
                        .environmentObject(settingsState)
                case .quiz:
                    ColorQuizView(showColorNames: false, debugMode: false)
                        .environmentObject(gameState)
                        .environmentObject(resultState)
                        .environmentObject(settingsState)
                        .transition(.opacity)
                case .results:
                    QuizResultsView()
                        .environmentObject(menuState)
                        .environmentObject(gameState)
                        .environmentObject(resultState)
                        .environmentObject(settingsState)
                        .transition(.opacity)
            }
        }
        .onAppear() {
            menuState.isMenuActive = false
            SoundPlayer.shared.playSound(type: .click)
        }
        .navigationBarItems(
            leading:
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(_globalNavBarButtonsColor)
                    
                    Button("menu-button") {
                        gameState.endGameSession()
                        menuState.isMenuActive = true
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(BackButton())
                }
        )
    }
}

struct Quiz2MainView_Previews: PreviewProvider {
    static var previews: some View {
        ColorQuizMainView()
    }
}
