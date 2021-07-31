//
//  CoreDataManager.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 31.07.2021.
//

import Foundation
import CoreData
import SwiftUI

class CoreDataManager {
    
    private init() { }
    
    static let shared = CoreDataManager()
    
    let context = PersistenceController.shared.container.viewContext
    
    func updateQuizScore(correctAnswers: Int, totalCards: Int, cardsViewed: [ColorModel: Bool]) {
        let fetchRequest: NSFetchRequest<ColorQuizStats> = ColorQuizStats.fetchRequest()
        
        do {
            let statsArray = try context.fetch(fetchRequest)
            var colorQuizStats: ColorQuizStats
            
            // если таблица есть, то заносим данные
            if statsArray.count > 0 {
                colorQuizStats = statsArray.first!
            }
            else {
                colorQuizStats = createColorQuizStatsTable() // если таблицы нет, то создаем
            }
            
            colorQuizStats.colorsGuessed += Int16(correctAnswers)

            cardsViewed.forEach { (color, isGuessed) in
                let viewedColor = ViewedColors(context: context)
                viewedColor.colorID = color.hexCode
                viewedColor.isGuessed = isGuessed
            }

            if correctAnswers == totalCards {
                colorQuizStats.strikesCount += 1
            }
        } catch {
            print("Couldn't fetch a ColorQuiz data")
        }
    }
    
    func updatePlayerScore(by scoreIncrement: Int) {
        let fetchRequest: NSFetchRequest<OverallStats> = OverallStats.fetchRequest()
        
        do {
            let playerStatsArray = try context.fetch(fetchRequest)
            var playerStats: OverallStats
            
            if playerStatsArray.count > 0  {
                playerStats = playerStatsArray.first!
            }
            else {
                playerStats = createOverallStatsTable()
            }

            let totalScore = playerStats.totalScore
            playerStats.totalScore = totalScore + Int32(scoreIncrement)
            
            do {
                try context.save()
            } catch {
                print("error during score save")
            }
            
            print("Now TotalScore is: \(playerStats.totalScore)")
        }
        catch {
            print("Couldn't fetch a score data")
        }
    }
    
    func createOverallStatsTable() -> OverallStats {
        let playerStats = OverallStats(context: context)
        playerStats.totalScore = 0
        playerStats.lastGameScore = 0
        playerStats.totalFinishedGames = 0
        
        do {
            try context.save()
        } catch {
            print("error during create score table")
        }
        
        return playerStats
    }
    
    func createColorQuizStatsTable() -> ColorQuizStats {
        let quizStats = ColorQuizStats(context: context)
        quizStats.colorsGuessed = 0
        quizStats.finishedGames = 0
        quizStats.strikesCount = 0
        quizStats.bestStrike = 0
        
        do {
            try context.save()
        } catch {
            print("error during create ColorQUIZ table")
        }
        
        return quizStats
    }
}
