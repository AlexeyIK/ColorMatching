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
    var showName: Bool
    var showColor: Bool = true
    var transparencyOn: Bool = false
    var glowOffset: (CGSize, CGSize) = (CGSize(width: 0.9, height: 0.9), CGSize(width: 1.5, height: 1.5))
    
    var body: some View {
        
        let currentColor: Color = ColorConvert(rgb: colorModel.colorRGB)
        let shadowColor: Color = Color.init(hue: Double(colorModel.colorHSV[0] ?? 0) / 360,
                                            saturation: Double(colorModel.colorHSV[1] ?? 0) / 100,
                                            brightness: Double(colorModel.colorHSV[2] ?? 0) / 220,
                                            opacity: 0.6)
        
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(showColor ? currentColor : _globalGrayedCardColor)
                .shadow(color: drawShadow ? (showColor ? shadowColor : Color.black) : Color.clear, radius: 12, x: -1, y: -3)
                // эффект градиентной обводки
                .overlay(drawBorder ?
                    RoundedRectangle(cornerRadius: 24)
                            .stroke(AngularGradient(gradient: Gradient(colors: [showColor ? currentColor : _globalGrayedCardColor, Color.clear]), center: .topTrailing, startAngle: .degrees(-30), endAngle: .degrees(225)), lineWidth: 2)
                            .brightness(0.6)
                    : nil
                )
                // эффект блика
                .overlay(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.init(red: 200, green: 200, blue: 200), Color.clear]), startPoint: UnitPoint(x: glowOffset.0.width, y: glowOffset.0.height), endPoint: UnitPoint(x: glowOffset.1.width, y: glowOffset.1.height)).blur(radius: 40).opacity(0.4).clipShape(RoundedRectangle(cornerRadius: 24)), alignment: .center)
                .opacity(transparencyOn ? 0.95 : 1.0)
            
            if showName {
                Text(String(colorModel.name != "" ? colorModel.name : colorModel.englishName))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .foregroundColor(currentColor)
                    .colorInvert()
            }
        }
        .frame(minWidth: 110, idealWidth: 250, maxWidth: 270, minHeight: 110, idealHeight: 340, maxHeight: 350, alignment: .top)
    }
}

struct TransparentCardView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 8", "iPhone Xs"], id: \.self) { device in
            ZStack {
                BackgroundView()
                TransparentCardView(colorModel: colorsData[310], drawBorder: true, drawShadow: true, showName: true, transparencyOn: false)
                    .previewDevice(PreviewDevice(stringLiteral: device))
                    .previewDisplayName(device)
            }
        }
    }
}
