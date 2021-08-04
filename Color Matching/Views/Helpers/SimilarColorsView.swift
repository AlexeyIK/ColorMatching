//
//  SimilarColors.swift
//  Color Matching
//
//  Created by Alexey on 22.07.2021.
//

import SwiftUI

struct SimilarColorsView: View {
    
    @State var cardsList: [ColorModel] = []
    @State var simCard: [ColorModel] = []
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
                                    self.cardsList = GetSequentalNumOfCards(cardsArray: ColorsPickerHelper.shared.getColors(byHardness: .hard), numberOfCards: 1)
                                    self.simCard = SimilarColorPicker.shared.getSimilarColors(colorRef: cardsList[0], for: _definedHardness)
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
                .foregroundColor(_globalAnswersColor)
                .background(_globalButtonBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .offset(y: -10)
            }
        }
        .onAppear(perform: {
            cardsList = GetSequentalNumOfCards(cardsArray: ColorsPickerHelper.shared.getColors(byHardness: .hard), numberOfCards: 1)
            simCard = SimilarColorPicker.shared.getSimilarColors(colorRef: cardsList[0], for: _definedHardness)
        })
    }
}

struct SimilarColors_Previews: PreviewProvider {
    static var previews: some View {
        SimilarColorsView()
    }
}
