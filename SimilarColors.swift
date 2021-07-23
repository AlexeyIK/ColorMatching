//
//  SimilarColors.swift
//  Color Matching
//
//  Created by Alexey on 22.07.2021.
//

import SwiftUI

struct SimilarColorsView: View {
    
    let card = colorsData[100]
//    let similarCards = SimilarColorPicker.shared.getSimilarColors(colorRef: colorsData[100])
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            VStack {
                ColorCardMinimalView(colorModel: card, drawBorder: true, drawShadow: true)
//                ColorCardMinimalView(colorModel: similarCards[0] ?? card, drawBorder: true, drawShadow: true)
//                ColorCardMinimalView(colorModel: similarCards[1] ?? card, drawBorder: true, drawShadow: true)
            }
        }
    }
}

struct SimilarColors_Previews: PreviewProvider {
    static var previews: some View {
        SimilarColorsView()
    }
}
