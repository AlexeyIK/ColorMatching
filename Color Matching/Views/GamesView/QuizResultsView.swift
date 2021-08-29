//
//  QuizResultsView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 01.08.2021.
//

import SwiftUI

struct QuizResultsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var gameState: LearnAndQuizState
    @EnvironmentObject var resultsStore: QuizResultsStore
    @EnvironmentObject var menuState: MenuState
    @EnvironmentObject var settingsState: SettingsState
    
    @State var resultsCaptionOffset: CGFloat = -UIScreen.main.bounds.height * 0.5
    @State var scoreCaptionOffset: CGFloat = -UIScreen.main.bounds.width * 0.8
    @State var bonusScale: CGFloat = 0
    @State var totalCaptionOffset: CGFloat = UIScreen.main.bounds.width * 0.8
    @State var isVisible: Bool = false
    @State var hueAngle: Double = 0.0
    
    let tactileFeedback = TactileGeneratorManager()
    
    var repeatingLinesAnimation: Animation {
        Animation
            .linear(duration: 2)
            .repeatForever()
    }
    
    var body: some View {
        let contentZone = UIScreen.main.bounds
        
        VStack {
            Spacer()
            
            if resultsStore.quizResults.correctAnswers == resultsStore.quizResults.cardsCount {
                Text("guessed-all-cards")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding()
                    .multilineTextAlignment(.center)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                    .transition(.identity)
            } else {
                Text("You guessed \(resultsStore.quizResults.correctAnswers) of \(resultsStore.quizResults.cardsCount) card(s)")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding()
                    .multilineTextAlignment(.center)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
            }
        
            VStack(spacing: 12) {
                HStack {
                    Text("\(resultsStore.quizResults.scoreEarned > 0 ? "+" : "")\(resultsStore.quizResults.scoreEarned - resultsStore.quizResults.strikeBonus)")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                        .offset(x: scoreCaptionOffset)
                    
                    Image("iconColorCoin28")
                        .resizable()
                        .frame(width: 28, height: 28, alignment: .center)
                        .offset(x: -4 - scoreCaptionOffset, y: 0)
                }
                .animation(Animation.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 0).delay(0.6), value: scoreCaptionOffset)
                
                if (resultsStore.quizResults.strikeBonus > 0) {
                    Text("\(resultsStore.quizResults.strikeMultiplier) strike-bonus")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                        .scaleEffect(bonusScale)
                        .animation(Animation.spring(response: 0.2, dampingFraction: 0.3, blendDuration: 0).delay(1.25), value: bonusScale)
                    
                    HStack {
                        Text("= \(resultsStore.quizResults.scoreEarned)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                            .offset(x: totalCaptionOffset)
                        
                        Image("iconColorCoin28")
                            .resizable()
                            .frame(width: 28, height: 28, alignment: .center)
                            .offset(x: -4 - totalCaptionOffset)
                    }
                    .animation(Animation.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 0).delay(2), value: totalCaptionOffset)
                }
            }
            .padding()
            .frame(width: contentZone.width, alignment: .center)
            .rainbowOverlay()
            .hueRotation(Angle(degrees: hueAngle))
            .animation(repeatingLinesAnimation, value: hueAngle)
            .onAppear() {
                self.hueAngle = 360
            }
            
            Spacer()
            
            Button("main-menu-button") {
                menuState.isMenuActive = true
                tactileFeedback.generateFeedback(style: .light, if: settingsState.tactileFeedback)
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(GoButton2())
            .font(.body)
            .frame(width: contentZone.width, alignment: .center)
            .transition(.move(edge: .bottom))
            .animation(Animation.easeOut(duration: 0.3).delay(0.3))
            
            Button("next-game-button") {
                tactileFeedback.generateFeedback(style: .medium, if: settingsState.tactileFeedback)
                gameState.restartGameSession()
            }
            .buttonStyle(GoButton2())
            .font(.title)
            .frame(width: contentZone.width, alignment: .center)
            .padding(.bottom, 40)
            .transition(.move(edge: .bottom))
            .animation(Animation.easeOut(duration: 0.3).delay(0.3))
            
        }
        .onAppear() {
            withAnimation() {
                self.isVisible.toggle()
                self.resultsCaptionOffset = 0
                self.scoreCaptionOffset = 0
                self.bonusScale = 1
                self.totalCaptionOffset = 0
            }
        }
    }
}

struct QuizResultsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                BackgroundView()
                QuizResultsView()
                    .environmentObject(LearnAndQuizState(quizType: .colorQuiz))
                    .environmentObject(QuizResultsStore())
            }
            ZStack {
                BackgroundView()
                QuizResultsView()
                    .environmentObject(LearnAndQuizState(quizType: .colorQuiz))
                    .environmentObject(QuizResultsStore())
                    .environment(\.locale, Locale(identifier: "ru"))
            }
        }
    }
}

extension View {
    func rainbowOverlay() -> some View {
        self
//            .overlay(LinearGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), startPoint: .leading, endPoint: .trailing).scaleEffect(1.5))
            .overlay(AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center))
            .brightness(0.3)
            .mask(self.blur(radius: 8))
            .overlay(self.opacity(0.9))
    }
}
