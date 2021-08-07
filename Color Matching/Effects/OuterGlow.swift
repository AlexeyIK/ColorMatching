//
//  OuterGlow.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 07.08.2021.
//

import SwiftUI

extension View {
    func glow(color: Color = .white, radius: CGFloat = 20) -> some View {
        self
//            .overlay(self.blur(radius: radius / 5).opacity(opacity))
            .shadow(color: color, radius: radius / 2, x: 0, y: 0)
            .shadow(color: color, radius: radius / 2, x: 0, y: 0)
    }
}
