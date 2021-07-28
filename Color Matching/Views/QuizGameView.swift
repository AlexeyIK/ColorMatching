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
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var countdown: Float = 60.0
    
    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                
                if quizState.results == nil {
                    Text("Quiz")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.light)
                        .padding(.bottom, 10)
                    
                    Spacer()
                }
                
                if quizState.quizActive {
                    ZStack {
                        ForEach(Array(quizState.quizItemsList.enumerated()), id: \.element) { (index, card) in
                            
                            TransparentCardView(colorModel: colorsData[card.correctId],
                                                 drawBorder: true,
                                                 drawShadow: index == quizState.quizItemsList.count - 1,
                                                 showName: showColorNames)
                                .offset(y: CGFloat(index) * -3).zIndex(-Double(index))
                                .scaleEffect(1.0 - CGFloat(index) / 250)
                                .zIndex(-Double(index))
                                .transition(.swipeToLeft)
                        }
                    }
                    
                    if quizState.quizItemsList.count > 0
                    {
                        VStack {
                            if let quizItem = quizState.getQuizItem() {
                                ForEach(quizItem.answers) { answer in
                                    let colorName = answer.name != "" ? answer.name : answer.englishName

                                    Button(colorName) {
                                        withAnimation() {
                                            quizState.quizItemsList.removeFirst()
                                        }
                                        
                                        _ = quizState.checkAnswer(for: quizItem, answer: answer.id)
                                    }
                                    .buttonStyle(QuizButton())
                                    .brightness(highlightCorrectAnswer && answer.id == quizItem.correctId ? 0.05 : 0)
                                    .transition(.identity)
                                }
                            }
                        }
                        .padding(.top, 25)
                        .padding(.bottom, 25)
                        .transition(.move(edge: .trailing))
                    }
                }
                
                if quizState.quizActive {
                    Spacer()

                    TimerView()
                        .foregroundColor(Color.white)
                        .environmentObject(quizState)
                }
                else if let results = quizState.results {
                    let finishText = quizState.timeRunOut ? "Время вышло!" : "Игра окончена!"

                    if results.correctAnswers == quizState.quizQuestions {
                        Text("\(finishText)\nВы угадали все карты!")
                            .foregroundColor(_globalMainTextColor)
                            .font(.title2)
                            .padding()
                            .multilineTextAlignment(.center)
                            .transition(.slide)
                    } else {
                        Text("\(finishText)\nУгадано \(results.correctAnswers) \(results.correctAnswers > 0 && results.correctAnswers < 5 ? "карты" : "карт") из \(results.cardsCount)")
                            .foregroundColor(_globalMainTextColor)
                            .font(.title2)
                            .padding()
                            .multilineTextAlignment(.center)
                            .transition(.slide)
                    }
                    
                    Button("Еще раз!") {
                        gameState.gameActive = false
                        gameState.activeGameMode = .learn
                    }
                    .buttonStyle(GoButton())
                }
            }
        }
        .onAppear(perform: {
            quizState.startQuiz(cards: gameState.cardsList, hardness: gameState.hardness)
        })
    }
}

struct QuizGameView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone Xs"], id: \.self) { device in
//        ForEach(["iPhone 8", "iPhone Xs"], id: \.self) { device in
            QuizGameView()
                .previewDevice(PreviewDevice(stringLiteral: device))
                .previewDisplayName(device)
                .environmentObject(LearnAndQuizState(definedHardness: .easy))
        }
    }
}

struct QuizButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
            .foregroundColor(_globalMainTextColor)
            .background(configuration.isPressed ? Color.init(hue: 0, saturation: 0, brightness: 0.5, opacity: 1) : Color.init(hue: 0, saturation: 0, brightness: 0.33, opacity: 1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct QuizButtonCorrect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
            .foregroundColor(_globalMainTextColor)
            .background(configuration.isPressed ? Color.init(red: 0.2, green: 1, blue: 0.2) : Color.init(hue: 0, saturation: 0, brightness: 0.33, opacity: 1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
