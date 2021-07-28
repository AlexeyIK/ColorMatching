//
//  BackgroundView.swift
//  Color Matching
//
//  Created by Alexey on 19.07.2021.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        RadialGradient(gradient:
                        Gradient(colors: [
                            Color.init(hue: 0, saturation: 0, brightness: 0.16),
                            Color.init(hue: 0, saturation: 0, brightness: 0.08)
                        ]),
                       center: UnitPoint(x: 0.5, y: 0.6),
                       startRadius: 1, endRadius: 400
        )
        .ignoresSafeArea()
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 8", "iPhone Xs"], id: \.self) { device in
            BackgroundView()
                .previewDevice(PreviewDevice(stringLiteral: device))
                .previewDisplayName(device)
        }
    }
}
