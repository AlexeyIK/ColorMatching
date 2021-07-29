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
//            TimerView()
            AllModesView()
//            LearnAndQuizView()
//            QuizGameView(hardnessLvl: .easy)
//            DeckView()
//            AnimationsTest()
//            SimilarColorsView()
//            ColorCardMinimalView(colorModel: colorsData[1201], drawBorder: true, drawShadow: true)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .accessibilityIgnoresInvertColors()
        }
    }
}
