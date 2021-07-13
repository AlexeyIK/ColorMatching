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
        
        let currentColor: Color = Color.init(red: Double(colorModel.colorRGB[0])/255, green: Double(colorModel.colorRGB[1])/255, blue: Double(colorModel.colorRGB[2])/255)
        
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(currentColor)
                .frame(width: 300, height: 400, alignment: .center)
                .shadow(color: .init(red: 0.75, green: 0.75, blue: 0.75), radius: 5, x: 3, y: 5)
                .animation(.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 0.001))
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.gray).opacity(0.2)
                    .frame(width: 300, height: 88, alignment: .bottom)
                    .shadow(color: .init(red: 0.75, green: 0.75, blue: 0.75), radius: 5, x: 3, y: 5)
                
                VStack {
                    Text(colorModel.name).font(.title)
                    VStack(alignment: .leading) {
                        Text("HEX: \(colorModel.hexCode)").font(.body)
                        Text("RGB: \(colorModel.colorRGB[0]), \(colorModel.colorRGB[1]), \(colorModel.colorRGB[2])").font(.body)
                    }
                }
            }
            .padding(.top, 25)
            .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.001))
            
        }
    }
}

struct ColorCardView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 8", "iPhone X"], id: \.self) { device in
            ColorCardView(colorModel: colorsData[0])
                .previewDevice(PreviewDevice(stringLiteral: device))
                .previewDisplayName(device)
        }
    }
}
