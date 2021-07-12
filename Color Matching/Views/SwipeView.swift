//
//  SwipeView.swift
//  Color Matching
//
//  Created by Alexey on 11.07.2021.
//

import SwiftUI

struct SwipeView: View {
    @State private var offset: CGFloat = 0
    @State private var index = 0
    
    let cards = colorsData
    let spacing: CGFloat = 10.0
    
    var body: some View {
        GeometryReader(content: { geometry in
            return ScrollView(.horizontal, showsIndicators: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/) {
                HStack(spacing: self.spacing) {
                    ForEach(self.cards) { card in
                        ColorCardView(colorModel: card)
                            .frame(width: geometry.size.width)
                    }
                }
            }
            .content.offset(x: self.offset)
            .frame(width: geometry.size.width, alignment: .leading)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        self.offset = value.translation.width - geometry.size.width * CGFloat(self.index)
                    })
                    .onEnded({ value in
                        if -value.predictedEndTranslation.width > geometry.size.width / 2, self.index < self.cards.count - 1 {
                               self.index += 1
                           }
                           if value.predictedEndTranslation.width > geometry.size.width / 2, self.index > 0 {
                               self.index -= 1
                           }
                           withAnimation { self.offset = -(geometry.size.width + self.spacing) * CGFloat(self.index) }
                    })
            )
        })
    }
}

struct SwipeView_Previews: PreviewProvider {
    static var previews: some View {
        SwipeView()
    }
}
