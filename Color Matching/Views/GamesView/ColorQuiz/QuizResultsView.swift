//
//  QuizResultsView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 01.08.2021.
//

import SwiftUI

struct QuizResultsView: View {
    
    @EnvironmentObject var gameState: LearnAndQuizState
    @EnvironmentObject var resultsStore: QuizResultsStore
    
    @State var hueAngle: Double = 0.0
    
    var repeatingLinesAnimation: Animation {
        Animation
            .linear(duration: 1)
            .repeatForever()
    }
    
    var body: some View {
        GeometryReader { contentZone in
            VStack {
                if resultsStore.quizResults.correctAnswers == resultsStore.quizResults.cardsCount {
                    Text("You have guessed all cards!")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding()
                        .multilineTextAlignment(.center)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                        .transition(.move(edge: .top))
                        .animation(.easeInOut)
                    
    //                            Text("Color coins earned:")
    //                                .foregroundColor(.white)
    //                                .font(.title2)
    //                                .padding()
    //                                .multilineTextAlignment(.center)
    //                                .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
    //                                .transition(.slide)
    //                                .animation(.easeInOut)
                } else {
                    Text("You guessed \(resultsStore.quizResults.correctAnswers) of \(resultsStore.quizResults.cardsCount) \(resultsStore.quizResults.cardsCount > 1 ? "cards" : "card" )")
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding()
                        .multilineTextAlignment(.center)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                        .transition(.move(edge: .top))
                        .animation(.easeInOut)
                    
    //                            Text("Color coins earned:")
    //                                .foregroundColor(.white)
    //                                .font(.title2)
    //                                .padding()
    //                                .multilineTextAlignment(.center)
    //                                .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
    //                                .transition(.slide)
    //                                .animation(.easeInOut)
                }
            
                VStack {
                    Text("\(resultsStore.quizResults.scoreEarned > 0 ? "+" : "")\(resultsStore.quizResults.scoreEarned - resultsStore.quizResults.strikeBonus) CC")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                    
                    if (resultsStore.quizResults.strikeBonus > 0) {
                        Text("x " + String(resultsStore.quizResults.strikeMultiplier))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                        
                        Text("= \(resultsStore.quizResults.scoreEarned) CC")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                    }
                    
                }
                .padding()
                .rainbowOverlay()
                .hueRotation(Angle(degrees: hueAngle))
                .animation(repeatingLinesAnimation, value: hueAngle)
                .onAppear() {
                    self.hueAngle = 360
                }
                
                ZStack {
                    Button("One more") {
                        gameState.restartGameSession()
                    }
                    .buttonStyle(GoButton2())
                }
                .font(.title)
                .frame(width: contentZone.size.width, alignment: .center)
                .transition(.move(edge: .trailing))
                .animation(Animation.linear.delay(0.3))
                .offset(y: contentZone.size.height * 0.25)
            }
        }
    }
}

struct QuizResultsView_Previews: PreviewProvider {
    static var previews: some View {
        QuizResultsView()
            .environmentObject(LearnAndQuizState())
            .environmentObject(QuizResultsStore())
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
