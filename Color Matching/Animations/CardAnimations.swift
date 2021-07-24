//
//  CardAnimations.swift
//  Color Matching
//
//  Created by Alexey on 18.07.2021.
//

import SwiftUI

enum SwipeDirection {
    case toLeft
    case toRight
}

struct SwipeCardAnimation: ViewModifier {
    var isActive: Bool = false
    var direction: SwipeDirection
    
    func body(content: Content) -> some View {
        return content
            .rotationEffect(.degrees(isActive ? (direction == .toLeft ? -15 : 15) : 0))
//            .opacity(isActive ? 0 : 1)
            .offset(x: isActive ? (direction == .toLeft ? -500 : 500) : 0)
    }
}

extension AnyTransition {
    static var swipeToLeft: AnyTransition {
        .modifier(
            active: SwipeCardAnimation(isActive: true, direction: .toLeft),
            identity: SwipeCardAnimation(isActive: false, direction: .toLeft)
        )
    }
    
    static var swipeToRight: AnyTransition {
        .modifier(
            active: SwipeCardAnimation(isActive: true, direction: .toRight),
            identity: SwipeCardAnimation(isActive: false, direction: .toRight)
        )
    }
}
