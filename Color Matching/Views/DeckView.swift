//
//  DeckView.swift
//  Color Matching
//
//  Created by Alexey on 16.07.2021.
//

import SwiftUI

struct DeckView: View {
    
    @GestureState var dragState: DragState = .inactive
    @State private var offset: CGFloat = 0
    @State private var index: Int = 0
    @State var slicedCardsList = Array(colorsData[1...10])
    @State var needToDropCard: Bool = false
    
//        let rndStart = Int.random(in: 0..<colorsData.count - numberOfCards)
//        let slicedCardsList = colorsData[rndStart...rndStart + numberOfCards]
    
    let cards = colorsData
    let numberOfCards = 12
    let swipeTreshold: CGFloat = 20
    
    var body: some View {
        
        let dragGesture = DragGesture()
            .updating($dragState) { (value, state, transc) in
                state = .dragging(translation: value.translation)
                self.needToDropCard = false
            }
            .onEnded({ value in
                if abs(value.translation.width) > swipeTreshold {
                    self.index += 1
                    self.needToDropCard = true
                }
            })
        
        VStack {
            ZStack {
                ForEach(slicedCardsList.indices) { indx in
                    if (indx >= index) {
                        if (indx == index && !self.needToDropCard) {
                            ColorCardMinimalView(colorModel: slicedCardsList[indx])
                                .offset(
                                    x: self.dragState.translation.width,
                                    y: 0
                                )
                                .rotationEffect(Angle(degrees: Double(dragState.translation.width / 30)))
                                .gesture(dragGesture)
                                .animation(.spring(response: 0.3, dampingFraction: 0.65, blendDuration: 0.01))
                                .transition(.move(edge: .leading))
                                .onDisappear() {
                                    if needToDropCard {
                                        self.needToDropCard = false
                                    }
                                }
                        }
                        else {
                            ColorCardMinimalView(colorModel: slicedCardsList[indx])
                                .offset(y: CGFloat(indx) * -2).zIndex(-Double(indx))
                        }
                    }
                }
                
                
//                ColorCardMinimalView(colorModel: slicedCardsList[index])
//                    .offset(
//                        x: self.dragState.translation.width,
//                        y: 0
//                    )
//                    .rotationEffect(Angle(degrees: Double(dragState.translation.width / 30)))
//                    .gesture(dragGesture)
//                    .animation(.spring(response: 0.3, dampingFraction: 0.65, blendDuration: 0.01))
//                    .transition(.move(edge: .leading))
                
            }
            
            Text("Cards remains: \(slicedCardsList.count - index)")
                .padding(.top, 20)
                .font(.title2)
        }
    }
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckView()
    }
}
