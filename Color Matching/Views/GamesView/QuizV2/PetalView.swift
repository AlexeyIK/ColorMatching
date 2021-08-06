//
//  PetalView.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 06.08.2021.
//

import SwiftUI

struct PetalView: View {
    
    @State var outerWidth: CGFloat = 45
    @State var innerWidth: CGFloat = 20
    
    let innerRoundness: CGFloat = 0.12
    let outerRoundness: CGFloat = 0.65
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let center = CGPoint(x: width * 0.5, y: height * 0.5)
                let startPoint = CGPoint(x: center.x - width * innerWidth / 100, y: center.y + height * 0.4)
                let topPoint = CGPoint(x: center.x, y: center.y)
                
                path.move(to: startPoint)
                
                path.addCurve(to: CGPoint(x: center.x + width * innerWidth / 100, y: startPoint.y),
                              control1: CGPoint(x: center.x - width * innerWidth / 150, y: startPoint.y + height * innerRoundness),
                              control2: CGPoint(x: center.x + width * innerWidth / 150, y: startPoint.y + height * innerRoundness))
                
                path.addLine(to: CGPoint(x: center.x + width * outerWidth / 100, y: topPoint.y))
                
                path.addCurve(to: CGPoint(x: center.x - width * outerWidth / 100, y: topPoint.y),
                              control1: CGPoint(x: center.x + width * 0.8, y: center.y - height * 0.65),
                              control2: CGPoint(x:  center.x - width * 0.8, y: center.y - height * 0.65))

                path.closeSubpath()
            }
        }
    }
}

struct PetalView_Previews: PreviewProvider {
    static var previews: some View {
        PetalView()
    }
}
