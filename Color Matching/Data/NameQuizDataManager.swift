//
//  NameQuizDataManager.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 07.08.2021.
//

import Foundation
import CoreData

class NameQuizDataManager {
    
    private init() { }

    static let shared = NameQuizDataManager()

    let context = PersistenceController.shared.container.viewContext
    
    func updateQuizStats(correctAnswers: Int, totalCards: Int, overallGameScore: Int)
    {
        let fetchRequest: NSFetchRequest<NameQuizStats> = NameQuizStats.fetchRequest()

        do {
            let statsArray = try context.fetch(fetchRequest)
            var colorQuizStats: NameQuizStats

            // если таблица есть, то заносим данные
            if statsArray.count > 0 {
                colorQuizStats = statsArray.first!
            }
            else { // если таблицы нет, то создаем
                colorQuizStats = createStatsTable()
            }

            colorQuizStats.finishedGames += 1
            colorQuizStats.namesGuessed += Int16(correctAnswers)

            if correctAnswers == totalCards {
                colorQuizStats.strikesCount += 1

                if colorQuizStats.bestStrike < correctAnswers {
                    colorQuizStats.bestStrike = Int16(correctAnswers)
                }
            }

            do {
                try context.save()
            } catch {
                print("Error during Name Quiz result save")
            }
        }
        catch {
            print("Couldn't fetch Name Quiz data")
        }
    }

    /// Сохраняем текущую выбранную сложность игры
    func writeCurrentHardness(_ hardness: Hardness) {
        let fetchRequest: NSFetchRequest<NameQuizStats> = NameQuizStats.fetchRequest()

        do {
            let statsArray = try context.fetch(fetchRequest)
            var colorQuizStats: NameQuizStats

            // если таблица есть, то заносим данные
            if statsArray.count > 0 {
                colorQuizStats = statsArray.first!
            }
            else { // если таблицы нет, то создаем
                colorQuizStats = createStatsTable()
            }

            colorQuizStats.lastPlayedHardness = Int16(hardness.rawValue)

            do {
                try context.save()
            } catch {
                print("Error during Name Quiz hardness save")
            }
        }
        catch {
            print("Couldn't fetch  Name Quiz data")
        }
    }
    
    /// Получаем прошлую выбранную сложность игры
    func getPreviousHardness() -> Int {
        let fetchRequest: NSFetchRequest<NameQuizStats> = NameQuizStats.fetchRequest()

        do {
            let quizStatsArray = try context.fetch(fetchRequest)
            var quizStats: NameQuizStats

            if quizStatsArray.count > 0  {
                quizStats = quizStatsArray.first!

                return Int(quizStats.lastPlayedHardness)
            }
        }
        catch {
            print("Couldn't fetch last Name Quiz played hardness data")
        }

        return 0
    }
    
    func createStatsTable() -> NameQuizStats {
        let quizStats = NameQuizStats(context: context)
        quizStats.namesGuessed = 0
        quizStats.finishedGames = 0
        quizStats.strikesCount = 0
        quizStats.bestStrike = 0

        do {
            try context.save()
        } catch {
            print("Error during create Name Quiz table")
        }

        return quizStats
    }
}

