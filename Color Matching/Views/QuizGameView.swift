//
//  QuizGameView.swift
//  Color Matching
//
//  Created by Alexey on 24.07.2021.
//

import SwiftUI

struct QuizGameView: View {
    
    @EnvironmentObject var gameState: LearnAndQuizState
    
    var hardnessLvl: Hardness
    var showColorNames: Bool
    var useTimer: Bool = false
    
//    @State var cardsList = QuizGameManager.shared.startGameSession(cardsInDeck: 7, with: .normal, shuffle: true)
//    @State var cardsList: [ColorModel] = []
    @State var currentQuizStep: Int = 0
    @State var correctAnswers: Int = 0
    @State var highlightCorrectAnswer: Bool = false
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var countdown: Float = 60.0
    
//    init(hardness: Hardness, showColorNames: Bool, useTimer: Bool = false) {
//        self.hardnessLvl = hardness
//        self.showColorNames = showColorNames
//        self.cardsList = cardsList
//        self.useTimer = useTimer
//        self.timer = QuizGameManager.shared.startTimer(for: gameState.hardness)
//    }
    
    var body: some View {
        ZStack {
            BackgroundView()

            VStack {
                if (QuizGameManager.shared.gameSessionActive && !gameState.timeRunOut) {
                    if (gameState.cardsList.count > 0) {
                        Text("Осталось карточек: \(gameState.cardsList.count)")
                            .foregroundColor(_globalMainTextColor)
                            .font(.title3)
                            .padding(.top, 10)
                        
                        Spacer()
                    }

                    ZStack {
                        ForEach(Array(gameState.cardsList.enumerated()), id: \.element) { (index, card) in
                            
                            TransparentCardView(colorModel: card,
                                                 drawBorder: true,
                                                 drawShadow: index == gameState.cardsList.count - 1,
                                                 showName: showColorNames)
                                .offset(y: CGFloat(index) * -3).zIndex(-Double(index))
                                .scaleEffect(1.0 - CGFloat(index) / 250)
                                .zIndex(-Double(index))
                                .transition(.swipeToLeft)
                        }
                    }
                    
                    if gameState.cardsList.count > 0
                    {
                        VStack {
                            if let quizItem = QuizGameManager.shared.getQuizItem() {
                                ForEach(quizItem.answers) { answer in
                                    let colorName = answer.name != "" ? answer.name : answer.englishName

                                    Button(colorName) {
                                        if QuizGameManager.shared.checkAnswer(for: quizItem, answer: answer.id) {
                                            correctAnswers = QuizGameManager.shared.correctAnswers
                                        }

                                        withAnimation {
                                            gameState.cardsList.removeFirst()
                                        }
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
                
                if gameState.cardsList.count > 0 && !gameState.timeRunOut {
                    Spacer()

                    TimerView(refDateTime: Date(timeIntervalSinceNow: 10))
                        .foregroundColor(Color.white)
                        .environmentObject(gameState)
                        .padding(.bottom, 10)
                    
                } else {
                    if QuizGameManager.shared.correctAnswers == QuizGameManager.shared.quizItemsList.count {
                        Text("Игра окончена!\nВы угадали все карты!")
                            .foregroundColor(_globalMainTextColor)
                            .font(.title2)
                            .padding()
                            .multilineTextAlignment(.center)
                            .transition(.slide)
                    } else {
                        Text("Игра окончена!\nУгадано \(QuizGameManager.shared.correctAnswers) \(QuizGameManager.shared.correctAnswers > 0 && QuizGameManager.shared.correctAnswers < 5 ? "карты" : "карт")")
                            .foregroundColor(_globalMainTextColor)
                            .font(.title2)
                            .padding()
                            .multilineTextAlignment(.center)
                            .transition(.slide)
                    }
                }
            }
        }
//        .onAppear() {
//            self.timer = QuizGameManager.shared.startTimer().autoconnect()
//        }
    }
}

struct QuizGameView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 8", "iPhone Xs"], id: \.self) { device in
            QuizGameView(hardnessLvl: .normal, showColorNames: true)
                .previewDevice(PreviewDevice(stringLiteral: device))
                .previewDisplayName(device)
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
