//
//  ColorCardMinimalView.swift
//  Color Matching
//
//  Created by Alexey on 16.07.2021.
//

import SwiftUI

struct ColorCardMinimalView: View {
    
    var colorModel: ColorModel
    
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
                
                
                Text(String(colorModel.id))
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .frame(width: 290, height: 400, alignment: .center)
//            .offset(y: -60)
//            .animation(.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 0.001))
        }
    }
}

struct ColorCardMinimalView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCardMinimalView(colorModel: colorsData[2])
    }
}
