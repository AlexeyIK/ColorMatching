//
//  LearnDeckView.swift
//  Color Matching
//
//  Created by Alexey on 16.07.2021.
//

import SwiftUI

struct CardState {
    var posX: CGFloat = 0
    var angle: Double = 0
}

struct LearnDeckView: View {
    
    @EnvironmentObject var gameState: LearnAndQuizState
    
    @State var needToDropCard: Bool = false
    @State var showColorNames: Bool = true
    @State var cardsState: [CardState] = Array(repeating: CardState(), count: 10)
    @State var currentIndex: Int = 0
    
    let swipeTreshold: CGFloat = 110
    
    var body: some View {
        GeometryReader { contentZone in
            ZStack {
                // фон
                BackgroundView()
                
                VStack {
                    if (currentIndex < gameState.cardsList.count) {
                        Text("Remember the colors")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.light)
    //                        .padding(.top, 10)
                            .padding(.bottom, 20)
                        
                        Spacer()
                    }
                    
                    if currentIndex < gameState.cardsList.count {
                        ZStack {
                            // отрисовка стопки карточек
                            ForEach(gameState.cardsList.indices, id: \.self) { i in
                                if (i >= currentIndex) {
                                    TransparentCardView(colorModel: gameState.cardsList[i],
                                                         drawBorder: true,
                                                         drawShadow: i == currentIndex,
                                                         showName: false,
                                                         showColor: i == currentIndex || i == currentIndex + 1, // окрашиваем в цвет не всё
                                                         glowOffset: (CGSize(width: 0.9 + self.cardsState[i].angle / 5, height: 0.9 + self.cardsState[i].angle / 5), CGSize(width: 1.25 + self.cardsState[i].angle / 10, height: 1.25 + self.cardsState[i].angle / 10)))
                                        .offset(
                                            x: self.cardsState[i].posX,
                                            y: CGFloat(i) * -4)
                                        .zIndex(-Double(i))
                                        .scaleEffect(1.0 - CGFloat(i) / 80)
                                        .rotationEffect(Angle(degrees: self.cardsState[i].angle))
                                        .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.01))
                                        .transition(self.cardsState[i].posX > 0 ? .swipeToRight : .swipeToLeft)
                                        // обработка драгов
                                        .gesture(DragGesture()
                                                    .onChanged({ value in
                                                        if (currentIndex == i) {
                                                            self.cardsState[i].posX = value.translation.width
                                                            self.cardsState[i].angle = Double(value.translation.width / 50)
                                                        }
                                                    })
                                                    .onEnded({ value in
                                                        if value.translation.width > swipeTreshold {
                                                            withAnimation() {
                                                                currentIndex += 1
                                                            }
                                                        }
                                                        else if value.translation.width < -swipeTreshold {
                                                            withAnimation() {
                                                                currentIndex += 1
                                                            }
                                                        }
                                                        else {
                                                            self.cardsState[i].posX = 0
                                                            self.cardsState[i].angle = 0
                                                        }
                                                    })
                                        )
                                }
                            }
                        }
                        .transition(.identity)
                        .frame(width: contentZone.size.width * 0.65, height: contentZone.size.height * 0.5, alignment: .center)
                    }
                    
                    // Вывод имени текущего цвета
                    if showColorNames && currentIndex < gameState.cardsList.count {
                        let colorName = gameState.cardsList[currentIndex].name != "" ? gameState.cardsList[currentIndex].name : gameState.cardsList[currentIndex].englishName
                        
                        Text(colorName)
                            .lineLimit(2)
                            .foregroundColor(_globalMainTextColor)
                            .font(.title2)
                            .frame(width: 280, height: 78, alignment: .top)
                            .multilineTextAlignment(.center)
                            .padding(.top, 25)
                            .transition(.opacity)
                            .animation(.none)
                    }

                    if currentIndex < gameState.cardsList.count {
                        Spacer()
                    } else {
                        Text("Теперь постарайся вспомнить названия цветов!")
                            .foregroundColor(_globalMainTextColor)
                            .font(.title2)
                            .padding()
                            .multilineTextAlignment(.center)
                            .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                            .frame(width: 350, alignment: .center)
                            .transition(.slide)
                            .animation(Animation.default.delay(0.4))
                        
                        Button("GO!") {
                            gameState.activeGameMode = .quiz
                        }
                        .buttonStyle(GoButton())
                        .frame(width: 350, alignment: .center)
                        .transition(.move(edge: .trailing))
                        .animation(Animation.linear.delay(0.6))
                    }
                }
                .transition(.identity)
            }
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        LearnDeckView()
            .environmentObject(LearnAndQuizState())
    }
}

struct GoButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 18, bottom: 10, trailing: 18))
            .foregroundColor(Color.white)
            .background(configuration.isPressed ? Color.init(hue: 240 / 360, saturation: 0.7, brightness: 0.8, opacity: 1) : Color.init(hue: 240 / 360, saturation: 0.7, brightness: 0.7, opacity: 1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: configuration.isPressed ? Color.white.opacity(0.2) : Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
    }
}
