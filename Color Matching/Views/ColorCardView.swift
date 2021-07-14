//
//  ColorCardView.swift
//  Color Matching
//
//  Created by Alexey on 12.07.2021.
//

import SwiftUI

struct ColorCardView: View {
    
    var colorModel: ColorModel
    
    var body: some View {
        
        let currentColor: Color = Color.init(
            red: Double(colorModel.colorRGB[0] ?? 0)/255,
            green: Double(colorModel.colorRGB[1] ?? 0)/255,
            blue: Double(colorModel.colorRGB[2] ?? 0)/255)
        
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(currentColor)
                .frame(width: 290, height: 400, alignment: .center)
                .shadow(color: .init(red: 0.8, green: 0.8, blue: 0.8), radius: 6, x: 3, y: 5)
                .animation(.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 0.001))
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.gray).opacity(0.2)
                    .frame(width: 270, height: 108, alignment: .leading)
                    .shadow(color: .init(red: 0.7, green: 0.7, blue: 0.7), radius: 6, x: 3, y: 5)
                
                VStack {
                    Text(colorModel.name).font(.title2)
                        .frame(minWidth: 100, idealWidth: 220, maxWidth: 250, minHeight: 3, idealHeight: 35, maxHeight: 35, alignment: .center)
                    VStack(alignment: .leading) {
                        Text("HEX: \(colorModel.hexCode)").font(.body)
                        Text("RGB: \(colorModel.colorRGB[0] ?? 0), \(colorModel.colorRGB[1] ?? 0), \(colorModel.colorRGB[2] ?? 0)").font(.body)
                        Text("HSV: \(colorModel.colorHSV[0] ?? 0), \(colorModel.colorHSV[1] ?? 0), \(colorModel.colorHSV[2] ?? 0)").font(.body)
                    }.frame(width: 220, alignment: .center)
                }
            }
            .padding(.top, 25)
            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.001))
            
        }
    }
}

struct ColorCardView_Previews: PreviewProvider {
    static var previews: some View {
//        ForEach(["iPhone X"], id: \.self) { device in
        ForEach(["iPhone 8", "iPhone X"], id: \.self) { device in
            ColorCardView(colorModel: colorsData[1])
                .previewDevice(PreviewDevice(stringLiteral: device))
                .previewDisplayName(device)
        }
    }
}
