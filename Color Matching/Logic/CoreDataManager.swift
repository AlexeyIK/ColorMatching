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
    
    func updatePlayerStats(scoreIncrement: Int) {
        let fetchRequest: NSFetchRequest<PlayerStats> = PlayerStats.fetchRequest()
        
        do {
            let playerStatsArray = try context.fetch(fetchRequest)
            var playerStats: PlayerStats
            
            if playerStatsArray.count > 0  {
                playerStats = playerStatsArray.first!
            }
            else {
                playerStats = PlayerStats(context: context)
                playerStats.totalScore = 0
                playerStats.guessedColors = 0
                playerStats.lastGameScore = 0
                
                do {
                    try context.save()
                } catch {
                    print("error during score save")
                }
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
            print("Couldn't save a score data")
        }
    }
}
