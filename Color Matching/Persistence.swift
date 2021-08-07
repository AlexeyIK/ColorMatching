//
//  Persistence.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 05.07.2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let overallStats = OverallStats(context: viewContext)
        overallStats.totalScore = 2200
        overallStats.lastGameScore = 68
        overallStats.totalFinishedGames = 11
        
        let nameQuizStats = NameQuizStats(context: viewContext)
        nameQuizStats.namesGuessed = 65
        nameQuizStats.finishedGames = 11
        nameQuizStats.bestStrike = 7
        nameQuizStats.strikesCount = 1
        
        let colorQuizStats = ColorQuizStats(context: viewContext)
        colorQuizStats.colorsGuessed = 35
        colorQuizStats.finishedGames = 6
        colorQuizStats.bestStrike = 5
        colorQuizStats.strikesCount = 2
        
        let color = ViewedColor(context: viewContext)
        color.colorId = "000000"
        color.isGuessed = false
        
        do {
            try viewContext.save()
        }
        catch {
            // Replace this implementation with code to handle the error appropriately.
            //            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Color_Matching")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
