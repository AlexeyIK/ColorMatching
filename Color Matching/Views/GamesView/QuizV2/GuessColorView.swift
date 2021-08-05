//
//  GuessColorView.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 05.08.2021.
//

import SwiftUI

struct GuessColorView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject var gameState: LearnAndQuizState
    @EnvironmentObject var resultStore: QuizResultsStore
    @StateObject var quizState: QuizState = QuizState()
    
    var highlightCorrectAnswer: Bool = false
    var showColorNames: Bool = false
    let scoreFlowSpeed: CGFloat = 55
    
    var body: some View {
        VStack {
            let contentZone = UIScreen.main.bounds
            
            if quizState.results == nil {
                if contentZone.height > 550 {
                    Text("Pick right color")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.light)
                }
            }
        }
    }
}

struct GuessColorView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            GuessColorView()
                .environmentObject(LearnAndQuizState())
                .environmentObject(QuizResultsStore())
        }
    }
}
