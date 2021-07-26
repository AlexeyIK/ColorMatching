//
//  DeckView.swift
//  Color Matching
//
//  Created by Alexey on 16.07.2021.
//

import SwiftUI

struct CardState {
    var posX: CGFloat = 0
    var angle: Double = 0
}

struct DeckView: View {
    
    @EnvironmentObject var gameState: LearnAndQuizState
    
//    @State var cardsList = LearnColorsGameManager.shared.StartGameSession(cardsInDeck: 7, with: .easy, shuffle: true)
    @State var cardsList: [ColorModel] = [colorsData[1000], colorsData[0]]
    @State var needToDropCard: Bool = false
    @State var showColorNames: Bool = true
    @State var swipeDirection: SwipeDirection = .toLeft
    @State var cardsState: [CardState] = []
    @State var currentIndex: Int = 0
    
    let swipeTreshold: CGFloat = 120
    
    var body: some View {
        
//        let simCard = SimilarColorPicker.shared.getSimilarColors(colorRef: cardsList[0])
        
        ZStack {
            BackgroundView()
            
            VStack {
                if (currentIndex < cardsList.count) {
                    Text("Осталось карточек: \(cardsList.count - currentIndex)")
                        .foregroundColor(_globalMainTextColor)
                        .font(.title3)
                        .padding(.bottom, 10)
                    
                    Spacer()
                }
                
                ZStack {
                    ForEach(cardsList.indices, id: \.self) { i in
                        // ToDo: подумать над тем, как сделать это через анимацию удаления
                        if (i >= currentIndex) {
                            TransparentCardView(colorModel: cardsList[i],
                                                 drawBorder: true,
                                                 drawShadow: i == cardsList.count - 1 || i == currentIndex,
                                                 showName: false,
//                                                 showName: i == currentIndex,
                                                 glowOffset: (CGSize(width: 0.9 + self.cardsState[i].angle / 5, height: 0.9 + self.cardsState[i].angle / 5), CGSize(width: 1.25 + self.cardsState[i].angle / 10, height: 1.25 + self.cardsState[i].angle / 10)))
                                .offset(
                                    x: self.cardsState[i].posX,
                                    y: CGFloat(i) * -2).zIndex(-Double(i)
                                )
                                .scaleEffect(1.0 - CGFloat(i) / 250)
                                .rotationEffect(Angle(degrees: self.cardsState[i].angle))
                                .zIndex(Double(i))
                                .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.01))
                                .transition(self.cardsState[i].posX > 0 ? .swipeToRight : .swipeToLeft)
//                                .transition(AnyTransition.asymmetric(insertion: .identity, removal: self.swipeDirection == .toRight ? .swipeToRight : .swipeToLeft))
                                .gesture(DragGesture()
                                            .onChanged({ value in
                                                self.cardsState[i].posX = value.translation.width
                                                self.cardsState[i].angle = Double(value.translation.width / 50)
                                            })
                                            .onEnded({ value in
                                                if value.translation.width > swipeTreshold {
                                                    withAnimation() {
//                                                        self.cardsState[i].posX = 400
//                                                        self.cardsState[i].angle = 15
                                                        currentIndex += 1
                                                    }
                                                }
                                                else if value.translation.width < -swipeTreshold {
                                                    withAnimation() {
//                                                        self.cardsState[i].posX = -400
//                                                        self.cardsState[i].angle = -15
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
                
//                if showColorNames && cardsList.count > 0 {
                if showColorNames && currentIndex < cardsList.count {
                    let colorName = cardsList[currentIndex].name != "" ? cardsList[currentIndex].name : cardsList[currentIndex].englishName
                    
                    Text(colorName)
                        .transition(.identity)
                        .lineLimit(2)
                        .foregroundColor(_globalMainTextColor)
                        .font(.title2)
                        .frame(width: 280, height: 58, alignment: .top)
                        .multilineTextAlignment(.center)
                        .padding(.top, 25)
                }
                
//                if cardsList.count > 0 {
                if currentIndex < cardsList.count {
                    Spacer()
                } else {
                    Text("Теперь постарайся вспомнить названия цветов!")
                        .foregroundColor(_globalMainTextColor)
                        .font(.title2)
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Button("Поехали!") {
                        cardsList = ShuffleCards(cardsArray: cardsList)
                        gameState.quizModeOn = true
                    }
                    .buttonStyle(MenuButton())
                }
            }
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView()
    }
}
