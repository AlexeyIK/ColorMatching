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
        Rectangle()
            .foregroundColor(Color.init(red: Double(colorModel.colorRGB[0])/255, green: Double(colorModel.colorRGB[1])/255, blue: Double(colorModel.colorRGB[2])/255))
            .frame(width: 300, height: 450, alignment: .center)
            .cornerRadius(20)
    }
}

struct ColorCardView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCardView(colorModel: colorsData[0])
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
