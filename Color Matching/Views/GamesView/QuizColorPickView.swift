//
//  QuizColorPickView.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 05.08.2021.
//

import SwiftUI

struct QuizColorPickView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject var gameState: LearnAndQuizState
    
    var body: some View {
        GeometryReader { contentZone in
            ZStack {
                BackgroundView()
                
                
            }
        }
    }
}

struct QuizColorPickView_Previews: PreviewProvider {
    static var previews: some View {
        QuizColorPickView()
    }
}
