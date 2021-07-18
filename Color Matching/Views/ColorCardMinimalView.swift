//
//  ColorCardMinimalView.swift
//  Color Matching
//
//  Created by Alexey on 16.07.2021.
//

import SwiftUI

struct ColorCardMinimalView: View {
    
    var colorModel: ColorModel
    var drawBorder: Bool
    var showName: Bool
    
    var body: some View {
        
        let currentColor: Color = Color.init(
            red: Double(colorModel.colorRGB[0] ?? 0)/255,
            green: Double(colorModel.colorRGB[1] ?? 0)/255,
            blue: Double(colorModel.colorRGB[2] ?? 0)/255)
        
        let shadowColor: Color = currentColor.opacity(0.2)
        
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(currentColor)
                    .shadow(color: shadowColor, radius: 10, x: 0, y: 0)
                    .overlay(drawBorder ?
                        RoundedRectangle(cornerRadius: 30)
                                .stroke(AngularGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.clear]), center: .topTrailing, startAngle: .degrees(45), endAngle: .degrees(315)), lineWidth: 4)
                        : nil
                    )
                
                
                Text(String(colorModel.id))
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .frame(width: 290, height: 400, alignment: .center)
//            .offset(y: -60)
//            .animation(.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 0.001))
            
            
            if showName {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.gray).opacity(0.2)
                        .shadow(color: .init(red: 0.4, green: 0.4, blue: 0.4), radius: 5, x: 0, y: 0)
                    
                    VStack {
                        Text(colorModel.name != "" ? colorModel.name : colorModel.englishName)
                            .lineLimit(2)
                            .font(.title2)
                            .frame(width: 250, height: 68, alignment: .center)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(width: 280, height: 50, alignment: .center)
                .padding(.top, 25)
                .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.001))
            }
            else {
                ZStack {}
                    .frame(width: 280, height: 50, alignment: .center)
                    .padding(.top, 25)
            }
        }
    }
}

struct ColorCardMinimalView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCardMinimalView(colorModel: colorsData[20], drawBorder: true, showName: true)
    }
}
