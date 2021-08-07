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
            let hightlightColor = Color.white.opacity(0.75)
//            let shadowColor = Color.init(hue: Double(colorModel.colorHSV[0] ?? 0) / 360,
//                                         saturation: Double(colorModel.colorHSV[1] ?? 0) / 100,
//                                         brightness: Double(colorModel.colorHSV[2] ?? 0) / 220,
//                                         opacity: 0.6)
            let shadowColor = Color.init(hue: 0, saturation: 0, brightness: 0.05)
            
            Petal()
                .fill(color)
                .overlay(Petal().stroke(AngularGradient(gradient: Gradient(colors: [color, Color.clear]), center: .topTrailing, startAngle: .degrees(-30), endAngle: .degrees(225)), lineWidth: 2).brightness(0.4))
                .shadow(color: shadowColor, radius: 6, x: 0, y: 0)
                .shadow(color: hightlight || blink ? hightlightColor.opacity(highlightOpacity) : .clear, radius: 8, x: 0, y: 0)
                .shadow(color: hightlight || blink ? hightlightColor.opacity(highlightOpacity) : .clear, radius: 8, x: 0, y: 0)
                .transition(.identity)
                .animation(blink ? Animation.easeInOut(duration: 0.15).repeatForever() : .none, value: blink)
                
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
    }
}

struct PetalView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            
            PetalView(colorModel: colorsData[300], name: colorsData[300].name, showNames: true, hightlight: false)
        }
    }
}

struct Petal: Shape {
    
    var outerWidth: CGFloat = 49
    var innerWidth: CGFloat = 18
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let innerRoundness: CGFloat = 0.1
        let outerRoundness: CGFloat = 0.65
        
        let startPoint = CGPoint(x: rect.midX - rect.width * innerWidth / 100, y: rect.midY + rect.height * 0.2)
        let topPoint = CGPoint(x: rect.midX, y: rect.midY - rect.height / 3)
        
        path.move(to: startPoint)
        path.addCurve(to: CGPoint(x: rect.midX + rect.width * innerWidth / 100, y: startPoint.y),
                      control1: CGPoint(x: rect.midX - rect.width * innerWidth / 135, y: startPoint.y + rect.height * innerRoundness),
                      control2: CGPoint(x: rect.midX + rect.width * innerWidth / 135, y: startPoint.y + rect.height * innerRoundness))
        path.addLine(to: CGPoint(x: rect.midX + rect.width * outerWidth / 100, y: topPoint.y))
        path.addCurve(to: CGPoint(x: rect.midX - rect.width * outerWidth / 100, y: topPoint.y),
                      control1: CGPoint(x: rect.midX + rect.width * outerRoundness * 0.9, y: -rect.height * 0.09),
                      control2: CGPoint(x: rect.midX - rect.width * outerRoundness * 0.9, y: -rect.height * 0.09))
        path.closeSubpath()
        
        return path
    }
}
