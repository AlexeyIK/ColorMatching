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

    func addViewedColors(_ viewedCards: [ColorModel]) {

        viewedCards.forEach { (color) in
            let fetchRequest: NSFetchRequest<ViewedColor> = ViewedColor.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "colorId == %@", color.hexCode)

            do {
                let colorsArray = try context.fetch(fetchRequest)

                if colorsArray.count != 0 {
                    colorsArray[0].isGuessed = color.isGuessed
                }
                else {
                    let viewedColor = ViewedColor(context: context)
                    viewedColor.colorId = color.hexCode
                    viewedColor.isGuessed = color.isGuessed
                }

                do {
                    try context.save()
                } catch {
                    print("Error during viewed colors update")
                }
            }
            catch {
                print("Couldn't fetch Viewed Colors data")
            }
        }
    }

    func showAllReadings() {
        let fetchRequest: NSFetchRequest<ViewedColor> = ViewedColor.fetchRequest()

        do {
            let colorsArray = try context.fetch(fetchRequest)

            /*
            // Логи просмотренных цветов
            colorsArray.forEach { (color) in
                print("color with hex: \(color.colorId ?? "-"), guessed: \(color.isGuessed)")
            }

            print("total count: \(colorsArray.count)")*/

        } catch {

        }
    }

    func updatePlayerScore(by scoreIncrement: Int)
    {
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

            playerStats.totalScore += Int32(scoreIncrement)
            if playerStats.totalScore < 0 { // не даем сделать общее количество очков < 0
                playerStats.totalScore = 0
            }

            do {
                try context.save()
            } catch {
                print("Error during score save")
            }

            print("Now TotalScore is: \(playerStats.totalScore)")
        }
        catch {
            print("Couldn't fetch score data")
        }
    }

    func writeLastGameScore(_ score: Int) {
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

            playerStats.lastGameScore = Int16(score) // добавляем к статистике очков за последнюю игру
            playerStats.totalFinishedGames += 1 // добавляем к статистике количества игр

            do {
                try context.save()
            } catch {
                print("Error during score save")
            }

            print("Last game score is: \(playerStats.lastGameScore)")
        }
        catch {
            print("Couldn't fetch score data")
        }
    }

    func getLastGameScore() -> Int {
        let fetchRequest: NSFetchRequest<OverallStats> = OverallStats.fetchRequest()

        do {
            let playerStatsArray = try context.fetch(fetchRequest)
            var playerStats: OverallStats

            if playerStatsArray.count > 0  {
                playerStats = playerStatsArray.first!

                return Int(playerStats.lastGameScore)
            }
        }
        catch {
            print("Couldn't fetch score data")
        }

        return 0
    }

    func resetLastGameScore() {
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

            playerStats.lastGameScore = 0 // обнуляем статистику очков за последнюю игру

            do {
                try context.save()
            } catch {
                print("Error during score save")
            }

            print("Last game score is: \(playerStats.lastGameScore)")
        }
        catch {
            print("Couldn't fetch score data")
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
            print("Error during create score table")
        }

        return playerStats
    }
}
