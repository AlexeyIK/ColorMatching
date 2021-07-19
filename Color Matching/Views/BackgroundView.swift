//
//  BackgroundView.swift
//  Color Matching
//
//  Created by Alexey on 19.07.2021.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ConvertColor(colorType: .rgba, value: (68, 68, 68, 1)).ignoresSafeArea()
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
