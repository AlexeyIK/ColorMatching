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
    @State var slicedCardsList = GetSequentalNumOfCards(cardsArray: colorsData, numberOfCards: 5)
    @State var needToDropCard: Bool = false
    @State var viewAppear = false
    @State var showColorNames: Bool = true
    
    let cards = colorsData
    let swipeTreshold: CGFloat = 180
    
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
                else {
                    self.needToDropCard = false
                }
            })
        
        ZStack {
            BackgroundView()
            
            VStack {
                
                if (index < slicedCardsList.count) {
                    Spacer()
                }
                
                ZStack {
                    ForEach(slicedCardsList.indices) { indx in
                        if (indx >= index) {
                            if (indx == index && !self.needToDropCard) {
                                ColorCardMinimalView(colorModel: slicedCardsList[indx],
                                                     drawBorder: true,
                                                     drawShadow: index == slicedCardsList.count - 1)
                                    .offset(
                                        x: self.dragState.translation.width,
                                        y: CGFloat(indx) * -1).zIndex(-Double(indx)
                                    )
                                    .rotationEffect(Angle(degrees: Double(dragState.translation.width / 30)))
                                    .gesture(dragGesture)
                                    .animation(self.viewAppear ? .spring(response: 0.25, dampingFraction: 0.6, blendDuration: 0.01) : nil)
    //                                .transition(.cardDisappear)
                                    .transition(self.dragState.translation.width > 0 ? .move(edge: .trailing) : .move(edge: .leading))
                                    .onAppear() {
                                        self.viewAppear = true
                                    }
                                    .onDisappear() {
                                        if needToDropCard {
                                            self.needToDropCard = false
                                            self.viewAppear = false
                                        }
                                    }
                            }
                            else {
                                ColorCardMinimalView(colorModel: slicedCardsList[indx], drawBorder: true, drawShadow: indx == slicedCardsList.count - 1)
                                    .offset(y: CGFloat(indx) * -1).zIndex(-Double(indx))
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
                
                if showColorNames && index < slicedCardsList.count {
                    ZStack {
                        Text(slicedCardsList[index].name != "" ? slicedCardsList[index].name : slicedCardsList[index].englishName)
                            .lineLimit(2)
                            .foregroundColor(_globalMainTextColor)
                            .font(.title2)
                            .frame(width: 280, height: 58, alignment: .top)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 230, height: 48, alignment: .center)
                    .padding(.top, 25)
                }
                
                if index < slicedCardsList.count {
                    Spacer()
                    
                    Text("Осталось карточек: \(slicedCardsList.count - index)")
                        .foregroundColor(_globalMainTextColor)
                        .font(.title3)
                } else {
                    Text("На этом пока все!")
                        .foregroundColor(_globalMainTextColor)
                        .font(.title)
                }
            }
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
