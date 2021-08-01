//
//  BackButtonView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 31.07.2021.
//

import SwiftUI

struct BackButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3)
            .foregroundColor(_globalNavBarButtonsColor)
            .shadow(color: configuration.isPressed ? Color.white.opacity(0.4) : Color.black.opacity(0.2), radius: 8, x: -1, y: -1)
    }
}
