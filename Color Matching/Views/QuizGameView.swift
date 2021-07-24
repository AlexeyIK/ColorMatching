//
//  QuizGameView.swift
//  Color Matching
//
//  Created by Alexey on 24.07.2021.
//

import SwiftUI

struct QuizGameView: View {
    
    var hardnessLvl: Hardness
    var showColorName: Bool
    
    @EnvironmentObject var gameState: LearnAndQuizState
    
//    @State var cardsList = LearnColorsGameManager.shared.StartGameSession(cardsInDeck: 7, with: .normal, shuffle: true)
    @State var cardsList: [ColorModel] = []
    @State var currentQuizStep: Int = 0
    @State var correctAnswers: Int = 0
    @State var highlightCorrectAnswer: Bool = false
    
    var body: some View {
        
        ZStack {
            BackgroundView()

            VStack {
                if (cardsList.count > 0) {
                    Spacer()
                }

                ZStack {
                    ForEach(Array(cardsList.enumerated()), id: \.element) { (index, card) in
                        
                        TransparentCardView(colorModel: card,
                                             drawBorder: true,
                                             drawShadow: index == cardsList.count - 1,
                                             showName: showColorName)
                            .offset(y: CGFloat(index) * -4).zIndex(-Double(index))
                            .scaleEffect(1.0 - CGFloat(index) / 100)
                            .zIndex(Double(index))
                            .transition(.swipeToLeft)
                            .onDisappear() {
                                highlightCorrectAnswer = false
                            }
                    }
                }
                
                if cardsList.count > 0 {
                    VStack {
                        let correctColor = cardsList.first!
                        let answers = SimilarColorPicker.shared.getSimilarColors(colorRef: correctColor, for: gameState.hardness, withRef: true).shuffled()
                        
                        ForEach(answers) { answer in
                            let colorName = answer.name != "" ? answer.name : answer.englishName

                            Button(colorName) {
                                if answer == correctColor {
                                    correctAnswers += 1
                                    highlightCorrectAnswer = true
                                }
                                
                                withAnimation {
                                    currentQuizStep += 1
                                    cardsList.removeFirst()
                                }
                            }
                            .buttonStyle(QuizButton())
                            .brightness(answer == correctColor ? 0.05 : 0)
                            .transition(.opacity)
                        }
                    }
                    .padding(.top, 25)
                    .padding(.bottom, 25)
                }
                
                if cardsList.count > 0 {
//                    Spacer()

                    Text("Осталось карточек: \(cardsList.count)")
                        .foregroundColor(_globalMainTextColor)
                        .font(.title3)
                        .padding(.bottom, 10)
                } else {
                    
                    if (correctAnswers == currentQuizStep) {
                        Text("Игра окончена!\nВы угадали все карты!")
                        .foregroundColor(_globalMainTextColor)
                        .font(.title2)
                        .padding()
                        .multilineTextAlignment(.center)
                    } else {
                        Text("Игра окончена!\nУгадано \(correctAnswers) \(correctAnswers > 0 && correctAnswers < 5 ? "карты" : "карт")")
                        .foregroundColor(_globalMainTextColor)
                        .font(.title2)
                        .padding()
                        .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct QuizGameView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 8", "iPhone Xs"], id: \.self) { device in
            QuizGameView(hardnessLvl: .normal, showColorName: true)
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
