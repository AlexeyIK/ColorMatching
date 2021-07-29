//
//  QuizGameView.swift
//  Color Matching
//
//  Created by Alexey on 24.07.2021.
//

import SwiftUI

struct QuizGameView: View {
    
    @EnvironmentObject var gameState: LearnAndQuizState
    @StateObject var quizState: QuizState = QuizState()
    
    var highlightCorrectAnswer: Bool = false
    var useTimer: Bool = false
    var showColorNames: Bool = false
    
    var body: some View {
        GeometryReader { contentZone in
            ZStack {
                BackgroundView()

                VStack {
                    if quizState.results == nil {
                        Text("Quiz")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.light)
                            .padding(10)
                        
                        Spacer()
                    }
                    
                    if quizState.quizActive {
                        ZStack {
                            ForEach(Array(quizState.quizItemsList.enumerated()), id: \.element) { (index, card) in
                                
                                TransparentCardView(colorModel: colorsData[card.correctId],
                                                     drawBorder: true,
                                                     drawShadow: index == 0,
                                                     showName: showColorNames,
                                                     showColor: index == 0)
                                    .offset(y: CGFloat(index) * -4).zIndex(-Double(index))
                                    .scaleEffect(1.0 - CGFloat(index) / 80)
                                    .zIndex(-Double(index))
                                    .transition(.swipeToLeft)
                            }
                        }
                        .transition(.opacity)
                        .frame(width: contentZone.size.width * 0.7, height: contentZone.size.height * 0.55, alignment: .center)
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
                                                _ = quizState.checkAnswer(for: quizItem, answer: answer.id)
                                            }
                                        }
                                        .transition(.identity)
                                        .buttonStyle(QuizButton())
                                        .brightness(highlightCorrectAnswer && answer.id == quizItem.correctId ? 0.05 : 0)
                                    }
                                }
                            }
                            .frame(height: 140)
                            .padding(.vertical, 12)
                            .transition(.identity)
                        }
                        else if quizState.timeRunOut && quizState.results == nil {
                            Text("Время вышло!")
                                .foregroundColor(_globalMainTextColor)
                                .font(.title2)
                                .padding()
                                .multilineTextAlignment(.center)
                                .padding(.vertical, 24)
                                .frame(height: 164)
                                .transition(.asymmetric(insertion: .scale, removal: .identity))
                        }
                    }
                    .animation(.easeIn(duration: 0.25))
                    
                    if quizState.quizActive {
                        Spacer()

                        TimerView()
                            .foregroundColor(Color.white)
                            .environmentObject(quizState)
                            .padding(.bottom, 15)
                    }
                    else if let results = quizState.results {
                        let finishText = "Игра окончена!"

                        if results.correctAnswers == quizState.quizQuestions {
                            Text("\(finishText)\nВы угадали все карты!")
                                .foregroundColor(_globalMainTextColor)
                                .font(.title2)
                                .padding()
                                .multilineTextAlignment(.center)
                                .transition(.slide)
                                .animation(.easeInOut)
                        } else {
                            Text("\(finishText)\nУгадано \(results.correctAnswers) \(results.correctAnswers > 0 && results.correctAnswers < 5 ? "карты" : "карт") из \(results.cardsCount)")
                                .foregroundColor(_globalMainTextColor)
                                .font(.title2)
                                .padding()
                                .multilineTextAlignment(.center)
                                .transition(.slide)
                                .animation(.easeInOut)
                        }
                        
                        ZStack {
                            Button("Еще раз!") {
                                gameState.restartGameSession()
                            }
                            .buttonStyle(GoButton())
                        }
                        .frame(width: 400)
                        .transition(.move(edge: .trailing))
                        .animation(Animation.linear.delay(0.3))
                    }
                }
                .frame(width: contentZone.size.width * 0.9, alignment: .center)
//                .animation(Animation.default.delay(0.25))
            }
            .onAppear(perform: {
                quizState.startQuiz(cards: gameState.cardsList, hardness: gameState.hardness)
            })
        }
    }
}

struct QuizGameView_Previews: PreviewProvider {
    static var previews: some View {
//        ForEach(["iPhone Xs"], id: \.self) { device in
        ForEach(["iPhone 8", "iPhone 11", "iPhone 12 mini"], id: \.self) { device in
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
