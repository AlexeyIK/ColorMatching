//
//  ColorCardMinimalView.swift
//  Color Matching
//
//  Created by Alexey on 16.07.2021.
//

import SwiftUI

struct ColorCardMinimalView: View {
        
    @State var isActive = false
    
    var colorModel: ColorModel
    var drawBorder: Bool
    var drawShadow: Bool
    
    var body: some View {
        
        let currentColor: Color = Color.init(
            red: Double(colorModel.colorRGB[0] ?? 0)/255,
            green: Double(colorModel.colorRGB[1] ?? 0)/255,
            blue: Double(colorModel.colorRGB[2] ?? 0)/255)
        
//        let shadowColor: Color = currentColor.opacity(0.3)
        let shadowColor: Color = Color.black.opacity(0.6)
        
        ZStack {
            // для дебага внешности, можно включить фоновый цвет
//            BackgroundView()
        
//            VStack {
//                if isActive {
//                    withAnimation {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(currentColor)
                                .shadow(color: drawShadow ? shadowColor : Color.clear, radius: 20, x: -1, y: -3)
                                .overlay(drawBorder ?
                                    RoundedRectangle(cornerRadius: 24)
                                            .stroke(AngularGradient(gradient: Gradient(colors: [currentColor, Color.clear]), center: .topTrailing, startAngle: .degrees(-30), endAngle: .degrees(225)), lineWidth: 4)
                                            .brightness(0.3)
                                    : nil
                                )
                            
//                            VStack {
//                                Text(String(colorModel.id))
//                                    .font(.largeTitle)
//                                    .foregroundColor(currentColor)
//                                    .colorInvert()
//                                Spacer()
//                            }.padding()
                        }
                        .frame(width: 280, height: 390, alignment: .center)
//                        .transition(.swipe)
//                    }
//                }
//
//                Button("Tap here", action: {
//                    withAnimation {
//                        self.isActive.toggle()
//                    }
//                }).padding(.top, 20)
//            }
        }
    }
}

struct ColorCardMinimalView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCardMinimalView(colorModel: colorsData[1610], drawBorder: true, drawShadow: true)
    }
}
