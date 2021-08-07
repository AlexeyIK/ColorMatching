//
//  PetalTestView.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 06.08.2021.
//

import SwiftUI

struct PetalTestView: View {
    
    @State var outerWidth: CGFloat = 45
    @State var innerWidth: CGFloat = 20
    
    let innerRoundness: CGFloat = 0.12
    let outerRoundness: CGFloat = 0.65
    
    @State var angle: Double = 0
    @State var perc: Double = 0
    
    var body: some View {
        VStack {
            Petal()
                .fill(Color.yellow)
                .frame(width: 100, height: 300, alignment: .center)
                .modifier(RollingModifier(toAngle: angle, percentage: perc, onFinish: {
                    perc = 0
                    
                    withAnimation() {
                        angle += 180
                    }
                }))
        
            Button("Animate") {
                withAnimation() {
                    angle += 180
                    perc = 1
                }
            }
        }
    }
}

struct RollingModifier: AnimatableModifier {
    
    var animatableData: Double {
        get { percentage }
        set {
            percentage = newValue
            checkIsFinish()
        }
    }
    
    var toAngle: Double = 0
    var percentage: Double
    var anchor: UnitPoint = .center
    let onFinish: () -> ()
    
    func checkIsFinish() {
        if (percentage == 1) {
            DispatchQueue.main.async {
                self.onFinish()
            }
        }
    }
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: toAngle), anchor: anchor)
      }
    
}

struct PetalTestView_Previews: PreviewProvider {
    static var previews: some View {
        PetalTestView()
    }
}

struct Petal: Shape {
    
    var outerWidth: CGFloat = 49
    var innerWidth: CGFloat = 18
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let innerRoundness: CGFloat = 0.1
        let outerRoundness: CGFloat = 0.6
        
        let startPoint = CGPoint(x: rect.midX - rect.width * innerWidth / 100, y: rect.midY + rect.height * 0.2)
        let topPoint = CGPoint(x: rect.midX, y: rect.midY - rect.height / 3)
        
        path.move(to: startPoint)
        path.addCurve(to: CGPoint(x: rect.midX + rect.width * innerWidth / 100, y: startPoint.y),
                      control1: CGPoint(x: rect.midX - rect.width * innerWidth / 135, y: startPoint.y + rect.height * innerRoundness),
                      control2: CGPoint(x: rect.midX + rect.width * innerWidth / 135, y: startPoint.y + rect.height * innerRoundness))
        path.addLine(to: CGPoint(x: rect.midX + rect.width * outerWidth / 100, y: topPoint.y))
        path.addCurve(to: CGPoint(x: rect.midX - rect.width * outerWidth / 100, y: topPoint.y),
                      control1: CGPoint(x: rect.midX + rect.width * outerRoundness * 0.95, y: -rect.height * 0.09),
                      control2: CGPoint(x: rect.midX - rect.width * outerRoundness * 0.95, y: -rect.height * 0.09))
        path.closeSubpath()
        
        return path
    }
}
