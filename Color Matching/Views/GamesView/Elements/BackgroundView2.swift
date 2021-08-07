//
//  BackgroundView2.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 07.08.2021.
//

import SwiftUI

struct BackgroundView2: View {
    var body: some View {
        GeometryReader { geometry in
            Color.init(hue: 0, saturation: 0, brightness: 0.08)
            
            RadialGradient(gradient:
                            Gradient(colors: [
                                Color.init(hue: 0, saturation: 0, brightness: 0.12),
                                Color.init(hue: 0, saturation: 0, brightness: 0.06)
                            ]),
                           center: UnitPoint(x: 1, y: 1),
                           startRadius: 1, endRadius: max(geometry.size.width, geometry.size.height)
            )
        }
        .ignoresSafeArea()
    }
}

struct BackgroundView2_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView2()
    }
}
