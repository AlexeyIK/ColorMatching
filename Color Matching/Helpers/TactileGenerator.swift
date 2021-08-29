//
//  TactileGenerator.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 29.08.2021.
//

import Foundation
import UIKit

class TactileGeneratorManager {
    
    init() {}
    
    func generateFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle, if allowed: Bool = true) {
        if allowed {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
            feedbackGenerator.impactOccurred()
        }
    }
}
