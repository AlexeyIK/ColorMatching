//
//  PetalView.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 07.08.2021.
//

import SwiftUI

struct PetalView: View {
    
    let colorModel: ColorModel
    var name: String = "???"
    var showNames: Bool = false
    var showColor: Bool = true
    var hightlight: Bool = false
    var blink: Bool = false
    
    @State var highlightOpacity: Double = 1
    
    var body: some View {
        ZStack {
            let color = showColor ? ConvertColor(rgb: colorModel.colorRGB) : _globalGrayedCardColor
            let hightlightColor = color.opacity(0.8)
            let shadowColor = Color.init(hue: Double(colorModel.colorHSV[0] ?? 0) / 360,
                                         saturation: Double(colorModel.colorHSV[1] ?? 0) / 100,
                                         brightness: Double(colorModel.colorHSV[2] ?? 0) / 220,
                                         opacity: 0.6)
            
            Petal()
                .fill(color)
                .overlay(Petal().stroke(AngularGradient(gradient: Gradient(colors: [color, Color.clear]), center: .topTrailing, startAngle: .degrees(-30), endAngle: .degrees(225)), lineWidth: 2).brightness(0.4))
                .shadow(color: shadowColor, radius: 8, x: 0, y: 0)
                .shadow(color: hightlight || blink ? hightlightColor.opacity(highlightOpacity) : .clear, radius: 8, x: 0, y: 0)
                .shadow(color: hightlight || blink ? hightlightColor.opacity(highlightOpacity) : .clear, radius: 10, x: 0, y: 0)
//                .shadow(color: hightlight ? hightlightColor : .clear, radius: 12, x: 0, y: 0)
                .transition(.identity)
                .animation(blink ? Animation.easeInOut(duration: 0.12).repeatForever() : .none, value: blink)
                
            if showNames {
                Text(name)
                    .foregroundColor(color)
                    .colorInvert()
                    .font(.caption)
                    .rotationEffect(Angle(degrees: 90), anchor: .center)
                    .offset(x: 0, y: -70)
                    .transition(.identity)
                    .animation(.none)
            }
        }
        .onAppear() {
            if blink {
                highlightOpacity = 0
            }
        }
//        .onChange(of: blink, perform: { value in
//            highlightOpacity = blink ? 0 : 1
//        })
    }
}

struct PetalView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView2()
            
            PetalView(colorModel: colorsData[300], name: colorsData[300].name, showNames: true, hightlight: true)
        }
    }
}
