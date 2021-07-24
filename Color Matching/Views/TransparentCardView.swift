//
//  TransparentCardView.swift
//  Color Matching
//
//  Created by Alexey on 23.07.2021.
//

import SwiftUI

struct TransparentCardView: View {
        
    @State var isActive = false
    
    var colorModel: ColorModel
    var drawBorder: Bool
    var drawShadow: Bool
    
    var body: some View {
        
        let currentColor: Color = Color.init(
            red: Double(colorModel.colorRGB[0] ?? 0)/255,
            green: Double(colorModel.colorRGB[1] ?? 0)/255,
            blue: Double(colorModel.colorRGB[2] ?? 0)/255)
        
        let shadowColor: Color = Color.init(hue: Double(colorModel.colorHSV[0] ?? 0) / 360, saturation: Double(colorModel.colorHSV[1] ?? 0) / 100, brightness: Double(colorModel.colorHSV[2] ?? 0) / 250, opacity: 0.6)
        
        ZStack {
            // для дебага внешности, можно включить фоновый цвет
//            BackgroundView()
        
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(currentColor)
                    .shadow(color: drawShadow ? shadowColor : Color.clear, radius: 12, x: -1, y: -3)
                    .overlay(drawBorder ?
                        RoundedRectangle(cornerRadius: 24)
                                .stroke(AngularGradient(gradient: Gradient(colors: [currentColor, Color.clear]), center: .topTrailing, startAngle: .degrees(-30), endAngle: .degrees(225)), lineWidth: 3)
                                .brightness(0.45)
                        : nil
                    )
                    .opacity(0.9)
                
                VStack {
                    Text(String(colorModel.name != "" ? colorModel.name : colorModel.englishName))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .font(.title3)
                        .foregroundColor(currentColor)
                        .colorInvert()
                        .opacity(0.7)
                }.padding()
            }
            .frame(width: 280, height: 390, alignment: .center)
        }
    }
}

struct TransparentCardView_Previews: PreviewProvider {
    static var previews: some View {
        TransparentCardView(colorModel: colorsData[1610], drawBorder: true, drawShadow: true)
    }
}
