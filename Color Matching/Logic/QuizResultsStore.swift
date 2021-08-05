//
//  QuizResultsStore.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 05.08.2021.
//

import Foundation
import SwiftUI

class QuizResultsStore: ObservableObject {
    
    init() { }
    
    @Published var quizResults: QuizResults = QuizResults(correctAnswers: 1, cardsViewed: 3, cardsCount: 5, scoreEarned: 128, strikeMultiplier: 2, strikeBonus: 64)
    @Published var colorsViewed: [ColorModel] = []
}
