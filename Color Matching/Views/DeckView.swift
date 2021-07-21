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
    
    @State var cardsList = LearnColorsGameManager.shared.StartGame(cardsInDeck: 10)
    @State var needToDropCard: Bool = false
    @State var showColorNames: Bool = true
    @State var swipeDirection: SwipeDirection = .toLeft
    @State var cardsState: [CardState] = Array(repeating: CardState(), count: LearnColorsGameManager.shared.savedCardsArray.count)
    @State var currentIndex: Int = 0
    
    let swipeTreshold: CGFloat = 120
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            VStack {
                if (currentIndex < cardsList.count) {
                    Spacer()
                }
                
                ZStack {
                    ForEach(cardsList.indices, id: \.self) { i in
                        // ToDo: подумать над тем, как сделать это через анимацию удаления
                        if (i >= currentIndex) {
                            ColorCardMinimalView(colorModel: cardsList[i],
                                                 drawBorder: true,
                                                 drawShadow: i == cardsList.count - 1)
                                .offset(
                                    x: self.cardsState[i].posX,
                                    y: CGFloat(i) * -4).zIndex(-Double(i)
                                )
                                .scaleEffect(1.0 - CGFloat(i) / 100)
                                .rotationEffect(Angle(degrees: self.cardsState[i].angle))
                                .zIndex(Double(i))
                                .animation(.spring(response: 0.25, dampingFraction: 0.6, blendDuration: 0.01))
                                .transition(self.cardsState[i].posX > 0 ? .swipeToRight : .swipeToLeft)
//                                .transition(AnyTransition.asymmetric(insertion: .identity, removal: self.swipeDirection == .toRight ? .swipeToRight : .swipeToLeft))
                                .gesture(DragGesture()
                                            .onChanged({ value in
                                                self.cardsState[i].posX = value.translation.width
                                                self.cardsState[i].angle = Double(value.translation.width / 50)
                                            })
                                            .onEnded({ value in
                                                if value.translation.width > swipeTreshold {
                                                    withAnimation(.linear) {
//                                                        self.cardsState[i].posX = 400
//                                                        self.cardsState[i].angle = 15
                                                        currentIndex += 1
                                                    }
                                                }
                                                else if value.translation.width < -swipeTreshold {
                                                    withAnimation(.linear) {
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
                    ZStack {
                        let colorName = cardsList.first?.name != "" ? cardsList.first!.name : cardsList.first!.englishName
                        
                        Text(colorName)
                            .lineLimit(2)
                            .foregroundColor(_globalMainTextColor)
                            .font(.title2)
                            .frame(width: 280, height: 58, alignment: .top)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 230, height: 48, alignment: .center)
                    .padding(.top, 25)
                }
                
//                if cardsList.count > 0 {
                if currentIndex < cardsList.count {
                    Spacer()
                    
                    Text("Осталось карточек: \(cardsList.count - currentIndex)")
                        .foregroundColor(_globalMainTextColor)
                        .font(.title3)
                        .padding(.bottom, 10)
                } else {
                    Text("Теперь постарайся вспомнить названия цветов!")
                        .foregroundColor(_globalMainTextColor)
                        .font(.title2)
                        .padding()
                        .multilineTextAlignment(.center)
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
