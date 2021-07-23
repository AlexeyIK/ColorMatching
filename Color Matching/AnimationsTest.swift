//
//  AnimationsTest.swift
//  Color Matching
//
//  Created by Alexey on 20.07.2021.
//

import SwiftUI

struct ColorItem: Identifiable, Hashable {
    var id: UUID = UUID()
    var color: Color
    
    init(_ col: Color = Color.black) {
        color = col
    }
}

struct AnimationsTest: View {
    
    let cardTypes: [Color] = [Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple, Color.gray, Color.pink]
    
    @State var cardsArray: [ColorItem] = [ColorItem(Color.red),
                                          ColorItem(Color.orange),
                                          ColorItem(Color.yellow),
                                          ColorItem(Color.green),
                                          ColorItem(Color.blue),
                                          ColorItem(Color.purple)]
    
    @State private var translation: CGSize = .zero
    @State var activeIndex: Int = 0
    
    var body: some View {
        // чтобы работало корректно надо использовать withAnimation на то действие, что повлекает за собой изменение списка или вьюшки
        // также проверять в симуляторе, а не в первьювере!!!
        
        VStack {
            ScrollView {
                
                ForEach(cardsArray, id: \.self) { card in
                        RoundedRectangle(cornerRadius: 24)
                            .fill(card.color)
                            .shadow(color: Color.gray.opacity(0.4), radius: 8, x: -1, y: -3)
                            .overlay(RoundedRectangle(cornerRadius: 24)
                                        .stroke(AngularGradient(gradient: Gradient(colors: [card.color, Color.clear]), center: .topTrailing, startAngle: .degrees(-30), endAngle: .degrees(225)), lineWidth: 3)
                                        .brightness(0.3)
                            )
                            .padding(.bottom, 4)
                            .frame(width: 250, height: 100, alignment: .center)
                            .transition(.swipeToRight)
                            .animation(.spring())
                            .onTapGesture {
                                withAnimation {
                                    if let index = self.cardsArray.firstIndex(of: card) {
                                        self.cardsArray.remove(at: index)
                                    }
                                }
                            }
                }
                .padding()
                .frame(width: 500, alignment: .top)
            }
            
            Spacer()
            
            Button("Add one") {
                withAnimation {
                    self.cardsArray.append(ColorItem(cardTypes[Int.random(in: 0..<cardTypes.count)]))
                }
            }
            .padding([.top, .bottom], 10)
            .padding([.leading, .trailing], 20)
            .border(Color.blue, width: 2)
        }
        .edgesIgnoringSafeArea(.top)
        .padding(.top, 10)
    }
}

struct AnimationsTest_Previews: PreviewProvider {
    static var previews: some View {
        AnimationsTest()
    }
}
