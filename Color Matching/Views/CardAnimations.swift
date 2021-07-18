//
//  CardAnimations.swift
//  Color Matching
//
//  Created by Alexey on 18.07.2021.
//

import SwiftUI

struct CardAnimations: ViewModifier {
    var isActive: Bool
    var direction: Direction
    
    func body(content: Content) -> some View {
        return content
            .scaleEffect(isActive ? 1.0 : 0.8)
            .opacity(isActive ? 1 : 0)
            .offset(x: direction == .none ? 0 : (direction == .toLeft ? -200 : 200))
    }
    
    enum Direction {
        case toLeft
        case toRight
        case none
    }
}

let cardDisappear = AnyTransition.modifier(
    active: CardAnimations(isActive: true, direction: .none),
    identity: CardAnimations(isActive: false, direction: .toLeft)
)
