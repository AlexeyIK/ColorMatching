//
//  ColorQuizDataManager.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 07.08.2021.
//

import Foundation
import CoreData

class ColorQuizDataManager {
    
    private init() { }

    static let shared = ColorQuizDataManager()

    let context = PersistenceController.shared.container.viewContext
    
    func updateQuizStats(correctAnswers: Int, totalCards: Int, overallGameScore: Int, hardness: Hardness)
    {
        let fetchRequest: NSFetchRequest<ColorQuizStats> = ColorQuizStats.fetchRequest()

        do {
            let statsArray = try context.fetch(fetchRequest)
            var colorQuizStats: ColorQuizStats

            // если таблица есть, то заносим данные
            if statsArray.count > 0 {
                colorQuizStats = statsArray.first!
            }
            else { // если таблицы нет, то создаем
                colorQuizStats = createStatsTable()
            }

            colorQuizStats.finishedGames += 1
            colorQuizStats.colorsGuessed += Int16(correctAnswers)
            
            switch hardness {
                case .easy:
                    colorQuizStats.easyCount += 1
                    break
                case .normal:
                    colorQuizStats.normalCount += 1
                    break
                case .hard:
                    colorQuizStats.hardCount += 1
                    break
                case .hell:
                    break
            }

            if correctAnswers == totalCards {
                colorQuizStats.strikesCount += 1

                if colorQuizStats.bestStrike < correctAnswers {
                    colorQuizStats.bestStrike = Int16(correctAnswers)
                }
            }

            do {
                try context.save()
            } catch {
                print("Error during Color QUIZ result save")
            }
        }
        catch {
            print("Couldn't fetch Color QUIZ data")
        }
    }
    
    /// Сохраняем текущую выбранную сложность игры
    func writeCurrentHardness(_ hardness: Hardness) {
        let fetchRequest: NSFetchRequest<ColorQuizStats> = ColorQuizStats.fetchRequest()

        do {
            let statsArray = try context.fetch(fetchRequest)
            var colorQuizStats: ColorQuizStats

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
                print("Error during Color QUIZ hardness save")
            }
        }
        catch {
            print("Couldn't fetch Color QUIZ data")
        }
    }
    
    /// Получаем прошлую выбранную сложность игры
    func getPreviousHardness() -> Int {
        let fetchRequest: NSFetchRequest<ColorQuizStats> = ColorQuizStats.fetchRequest()

        do {
            let quizStatsArray = try context.fetch(fetchRequest)
            var quizStats: ColorQuizStats

            if quizStatsArray.count > 0  {
                quizStats = quizStatsArray.first!

                return Int(quizStats.lastPlayedHardness)
            }
        }
        catch {
            print("Couldn't fetch last Color QUIZ played hardness data")
        }

        return 0
    }
    
    func createStatsTable() -> ColorQuizStats {
        let quizStats = ColorQuizStats(context: context)
        quizStats.colorsGuessed = 0
        quizStats.finishedGames = 0
        quizStats.strikesCount = 0
        quizStats.bestStrike = 0

        do {
            try context.save()
        } catch {
            print("Error during create Color QUIZ table")
        }

        return quizStats
    }
}
