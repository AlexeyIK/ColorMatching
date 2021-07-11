//
//  Color_MatchingApp.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 05.07.2021.
//

import SwiftUI

@main
struct Color_MatchingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ListView()
                .environmentObject(UserData())
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                
        }
    }
}
