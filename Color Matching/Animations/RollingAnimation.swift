//
//  RollingAnimation.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 07.08.2021.
//

import Foundation
import SwiftUI

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
            .rotationEffect(.degrees(toAngle), anchor: anchor)
    }
}
