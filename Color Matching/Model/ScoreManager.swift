//
//  ScoreManager.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 31.07.2021.
//

import Foundation

class ScoreManager {
    
    private init() { }
    
    static let shared = ScoreManager()
    
    private(set) var totalScore: Int = 0
    private(set) var lastGameScore: Int = 0
    
    func addScore(_ count: Int) {
        totalScore += count
    }
    
    func subtractScore(_ count: Int) {
        totalScore -= count
        if totalScore < 0 {
            totalScore = 0
        }
    }
    
    func getScoreByHardness(_ hardness: Hardness, answerCorrect: Bool) -> Int {
        if answerCorrect {
            switch hardness {
                case .easy:
                    return 12
                case .normal:
                    return 18
                case .hard:
                    return 24
                case .hell:
                    return 30
            }
        }
        else {
            switch hardness {
                case .easy:
                    return 0
                case .normal:
                    return 0
                case .hard:
                    return 0
                case .hell:
                    return -10
            }
        }
    }
}
