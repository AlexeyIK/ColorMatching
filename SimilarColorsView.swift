//
//  SimilarColors.swift
//  Color Matching
//
//  Created by Alexey on 22.07.2021.
//

import SwiftUI

struct SimilarColorsView: View {
    
    @State var cardsList = LearnColorsGameManager.shared.StartGameSession(cardsInDeck: 1, with: .easy)
    @State var simCard = SimilarColorPicker.shared.getSimilarColors(colorRef: LearnColorsGameManager.shared.savedCardsArray[0], for: LearnColorsGameManager.shared.currentHardness)
    @State var cardsState = CardState(posX: 0, angle: 0)
    
    var body: some View {
        
        ZStack {
            BackgroundView()
        
            VStack {
                Spacer()
            
                
                ZStack {
                    if cardsList.count > 0 {
                    TransparentCardView(colorModel: cardsList[0], drawBorder: true, drawShadow: true)
                        .rotationEffect(Angle(degrees: -15 + self.cardsState.angle), anchor: .bottom)
                        .animation(.spring())
                        .transition(.swipeToLeft)
                        .zIndex(-1)
                    }
                    
                    if (simCard.count > 0) {
                        TransparentCardView(colorModel: simCard[0], drawBorder: true, drawShadow: true)
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
                        TransparentCardView(colorModel: simCard[1], drawBorder: true, drawShadow: true)
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
            
                Button("Еще раз") {
                    withAnimation {
                        self.cardsList = []
                        self.simCard = []
                    }
                }
                .padding()
                .foregroundColor(.blue)
                .border(Color.blue, width: 2)
            }
        }
    }
}

struct SimilarColors_Previews: PreviewProvider {
    static var previews: some View {
        SimilarColorsView()
    }
}
