//
//  SimilarColors.swift
//  Color Matching
//
//  Created by Alexey on 22.07.2021.
//

import SwiftUI

struct SimilarColorsView: View {
    
    @State var cardsList = LearnColorsGameManager.shared.StartGameSession(cardsInDeck: 1, with: .hard)
    @State var simCard = SimilarColorPicker.shared.getSimilarColors(colorRef: LearnColorsGameManager.shared.savedCardsArray[0], for: LearnColorsGameManager.shared.currentHardness)
    @State var cardsState = CardState(posX: 0, angle: 0)
    
    var body: some View {
        
        ZStack {
            BackgroundView()
        
            VStack {
                Spacer()
            
                
                ZStack {
                    if cardsList.count > 0 {
                    TransparentCardView(colorModel: cardsList[0],
                                        drawBorder: true,
                                        drawShadow: true,
                                        showName: true,
                                        glowOffset: (CGSize(width: 0.75, height: 0.75 + self.cardsState.angle / 10), CGSize(width: 1.25, height: 1.5 + self.cardsState.angle / 20)))
                        .rotationEffect(Angle(degrees: -15 + self.cardsState.angle), anchor: .bottom)
                        .animation(.spring())
                        .transition(.swipeToLeft)
                        .zIndex(-1)
                    }
                    
                    if (simCard.count > 0) {
                        TransparentCardView(colorModel: simCard[0],
                                            drawBorder: true,
                                            drawShadow: true,
                                            showName: true,
                                            glowOffset: (CGSize(width: 0.75, height: 0.75 + self.cardsState.angle / 10), CGSize(width: 1.25, height: 1.5 + self.cardsState.angle / 20)))
                            .offset(x: self.cardsState.posX / 3)
                            .rotationEffect(Angle(degrees: self.cardsState.angle), anchor: .bottom)
                            .animation(.spring())
                            .transition(.opacity)
                            .onDisappear() {
                                withAnimation {
                                    self.cardsList = LearnColorsGameManager.shared.StartGameSession(cardsInDeck: 1, with: LearnColorsGameManager.shared.currentHardness)
                                    self.simCard = SimilarColorPicker.shared.getSimilarColors(colorRef: LearnColorsGameManager.shared.savedCardsArray[0], for: LearnColorsGameManager.shared.currentHardness)
                                }
                            }
                            .zIndex(1)
                    }
                    
                    if (simCard.count > 1) {
                        TransparentCardView(colorModel: simCard[1],
                                            drawBorder: true,
                                            drawShadow: true,
                                            showName: true,
                                            glowOffset: (CGSize(width: 0.75, height: 0.75 + self.cardsState.angle / 10), CGSize(width: 1.25, height: 1.5 + self.cardsState.angle / 20)))
                            .offset(x: self.cardsState.posX)
                            .rotationEffect(Angle(degrees: (15 + self.cardsState.angle)), anchor: .bottom)
                            .animation(.spring())
                            .transition(.swipeToRight)
                            .gesture(DragGesture()
                                        .onChanged({ value in
                                            self.cardsState.posX = value.translation.width
                                            self.cardsState.angle = Double(value.translation.width / 20)
                                        })
                                        .onEnded({ (value) in
                                            self.cardsState.posX = 0
                                            self.cardsState.angle = 0
                                        })
                            )
                            .zIndex(2)
                    }
                }
                
                Spacer()
            
                Button("Сгенерировать набор цветов") {
                    withAnimation {
                        self.cardsList = []
                        self.simCard = []
                    }
                }
                .padding()
                .foregroundColor(_globalMainTextColor)
                .background(_globalButtonBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .offset(y: -10)
            }
        }
    }
}

struct SimilarColors_Previews: PreviewProvider {
    static var previews: some View {
        SimilarColorsView()
    }
}
