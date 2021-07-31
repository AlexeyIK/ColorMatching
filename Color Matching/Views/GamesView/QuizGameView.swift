//
//  QuizGameView.swift
//  Color Matching
//
//  Created by Alexey on 24.07.2021.
//

import SwiftUI

struct QuizGameView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject var gameState: LearnAndQuizState
    @StateObject var quizState: QuizState = QuizState()
    
    @State var lastAnswerIsCorrect: Bool? = nil
    
    var highlightCorrectAnswer: Bool = false
    var useTimer: Bool = false
    var showColorNames: Bool = false
    let scoreFlowSpeed: CGFloat = 55
    
    var body: some View {
        GeometryReader { contentZone in
            ZStack {
                BackgroundView()

                VStack {
                    if quizState.results == nil {
                        if contentZone.size.height > 550 {
                            Text("Guess the color")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.light)
//                                .padding(.bottom, 10)
                        }
                    }
                    
                    if quizState.quizActive {
                        TimerView()
                            .foregroundColor(Color.white)
                            .environmentObject(quizState)
                        
                        Spacer()
                        
                        ZStack(alignment: .leading) {
                            ForEach(quizState.quizAnswersAndScore) { quizAnswer in
                                ScorePointView(score: quizAnswer.scoreEarned, isCorrect: quizAnswer.isCorrect)
                                    .offset(x: quizAnswer.startOffset * 10.0, y: -CGFloat(quizAnswer.lifetime) * scoreFlowSpeed)
                                    .opacity(1 - quizAnswer.lifetime)
                                    .scaleEffect(1 + CGFloat(quizAnswer.lifetime) / 10)
                                    .animation(.easeOut)
                            }
                        }
//                        .offset(x: contentZone.size.width * 0.4, y: 12)
                        .offset(y: 6)
                        .frame(width: contentZone.size.width * 0.5, height: contentZone.size.height * 0.05, alignment: .bottom)
                    }
                    
                    if quizState.quizActive {
                        ZStack {
                            ForEach(Array(quizState.quizItemsList.enumerated()), id: \.element) { (index, card) in
                                
                                TransparentCardView(colorModel: colorsData[card.correctId],
                                                     drawBorder: true,
                                                     drawShadow: index == 0,
                                                     showName: showColorNames,
                                                     showColor: index == 0 && quizState.isAppActive)
                                    .offset(y: CGFloat(index) * -4).zIndex(-Double(index))
                                    .scaleEffect(1.0 - CGFloat(index) / 80)
//                                    .zIndex(-Double(index))
                                    .transition(quizState.isAppActive ? .swipeToLeft : .opacity)
                                    .animation(.easeInOut)
                            }
                        }
                        .transition(.opacity)
                        .frame(width: contentZone.size.width * 0.68, height: contentZone.size.height * 0.5, alignment: .center)
                    }
                    
                    VStack {
                        if quizState.quizItemsList.count > 0 && !quizState.timeRunOut
                        {
                            VStack(spacing: 8) {
                                if let quizItem = quizState.getQuizItem() {
                                    ForEach(quizItem.answers) { answer in
                                        let colorName = answer.name != "" ? answer.name : answer.englishName

                                        Button(colorName) {
                                            withAnimation {
                                                quizState.quizItemsList.removeFirst()
                                                lastAnswerIsCorrect = quizState.checkAnswer(for: quizItem, answer: answer.id, hardness: gameState.hardness)
                                            }
                                        }
                                        .transition(.identity)
                                        .buttonStyle(QuizButton())
                                        .animation(.none)
                                        .brightness(highlightCorrectAnswer && answer.id == quizItem.correctId ? 0.05 : 0)
                                    }
                                }
                            }
                            .frame(height: 120)
                            .padding(.vertical, 10)
                            .transition(.identity)
                        }
                        else if quizState.timeRunOut && quizState.results == nil {
                            Text("Time is over!")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding()
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 10)
                                .frame(height: 140)
                                .transition(.asymmetric(insertion: .scale, removal: .identity))
                        }
                    }
                    .animation(.easeIn(duration: 0.25))
                    
                    if !quizState.quizActive, let results = quizState.results {
//                        let finishText = "Game is over!"

                        if results.correctAnswers == quizState.quizQuestions {
                            Text("You have guessed all cards!")
                                .foregroundColor(.white)
                                .font(.title2)
                                .padding()
                                .multilineTextAlignment(.center)
                                .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                                .transition(.slide)
                                .animation(.easeInOut)
                        } else {
                            Text("You guessed \(results.correctAnswers) of \(results.cardsCount) \(results.cardsCount > 1 ? "cards" : "card" )")
                                .foregroundColor(_globalMainTextColor)
                                .font(.title2)
                                .padding()
                                .multilineTextAlignment(.center)
                                .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                                .transition(.slide)
                                .animation(.easeInOut)
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
                .padding()
                .blur(radius: quizState.isAppActive ? .nan : 10)
                .frame(width: contentZone.size.width * 0.9, alignment: .center)
//                .animation(Animation.default.delay(0.25))
            }
            .onAppear(perform: {
                quizState.startQuiz(cards: gameState.cardsList, hardness: gameState.hardness)
            })
            // мониторим, что приложение свернули и паузим таймер и сменяем статус
            .onChange(of: scenePhase) { phase in
                switch phase {
                    case .inactive:
                        quizState.isAppActive = false
                        quizState.pauseTimer()
                    case .active:
                        quizState.isAppActive = true
                        quizState.resumeTimer()
                    default:
                        return
                }
            }
        }
    }
}

struct QuizGameView_Previews: PreviewProvider {
    static var previews: some View {
//        ForEach(["iPhone Xs"], id: \.self) { device in
        ForEach(["iPhone SE (1st generation)", "iPhone 8", "iPhone 12 mini"], id: \.self) { device in
            QuizGameView()
                .previewDevice(PreviewDevice(stringLiteral: device))
                .previewDisplayName(device)
                .environmentObject(LearnAndQuizState())
        }
    }
}

struct QuizButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .foregroundColor(_globalMainTextColor)
            .background(RoundedRectangle(cornerRadius: 36)
                            .stroke(configuration.isPressed ? Color.init(hue: 0, saturation: 0, brightness: 0.5, opacity: 1) : Color.init(hue: 0, saturation: 0, brightness: 0.33, opacity: 1), lineWidth: 3)
                            .overlay(configuration.isPressed ? RoundedRectangle(cornerRadius: 36).fill(Color.init(hue: 0, saturation: 0, brightness: 0.5, opacity: 1)) : nil)
            )
            .clipShape(RoundedRectangle(cornerRadius: 36))
    }
}

struct QuizButtonCorrect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
            .foregroundColor(_globalMainTextColor)
            .background(configuration.isPressed ? Color.init(red: 0.2, green: 1, blue: 0.2) : Color.init(hue: 0, saturation: 0, brightness: 0.33, opacity: 1))
            .clipShape(RoundedRectangle(cornerRadius: 36))
    }
}
