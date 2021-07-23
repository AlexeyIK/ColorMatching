//
//  SimilarColors.swift
//  Color Matching
//
//  Created by Alexey on 22.07.2021.
//

import SwiftUI

struct SimilarColorsView: View {
    
    @State var cardsList = LearnColorsGameManager.shared.StartGameSession(cardsInDeck: 1, with: .normal)
    
    var body: some View {
        
        let simCard = SimilarColorPicker.shared.getSimilarColors(colorRef: cardsList[0], for: LearnColorsGameManager.shared.currentHardness)
        
        ZStack {
            BackgroundView().ignoresSafeArea()
        
            VStack {
                Spacer()
            
                ZStack {
                    ColorCardMinimalView(colorModel: cardsList[0], drawBorder: true, drawShadow: true)
                        .offset(y: -100)
                        .animation(.easeIn)
                        .transition(.swipeToLeft)
                    
                    if (simCard[0] != nil) {
                        ColorCardMinimalView(colorModel: simCard[0]!, drawBorder: true, drawShadow: true)
                            .animation(.easeIn)
                            .transition(.swipeToRight)
                    }
                    if (simCard[1] != nil) {
                        ColorCardMinimalView(colorModel: simCard[1]!, drawBorder: true, drawShadow: true).offset(y: 100)
                            .animation(.easeIn)
                            .transition(.swipeToLeft)
                    }
                }
                
                Spacer()
            
                Button("Еще раз") {
                    cardsList = LearnColorsGameManager.shared.StartGameSession(cardsInDeck: 2, with: LearnColorsGameManager.shared.currentHardness)
                }
                .padding()
            }
        }
    }
}

struct SimilarColors_Previews: PreviewProvider {
    static var previews: some View {
        SimilarColorsView()
    }
}
