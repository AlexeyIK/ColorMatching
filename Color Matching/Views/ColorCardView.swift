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
                .foregroundColor(currentColor)
                .frame(width: 300, height: 450, alignment: .center)
                .padding(.top, 20.0)
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.gray).opacity(0.3)
                    .frame(minWidth: 100, idealWidth: 200, maxWidth: 300,
                           minHeight: 40, idealHeight: 40, maxHeight: 80,
                           alignment: .center)
                
                VStack {
                    Text(colorModel.name).font(.title)
                    Text("HEX: \(colorModel.hexCode)").font(.body)
                }
            }
            .padding(.top, 20)
            
        }.padding()
    }
}

struct ColorCardView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCardView(colorModel: colorsData[0])
    }
}
