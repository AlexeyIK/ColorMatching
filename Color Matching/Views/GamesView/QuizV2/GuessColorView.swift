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
    
    @State var phase: Double = 200
    
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
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Circle()
                        .stroke(AngularGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .pink, .red]), center: .center), style: StrokeStyle(lineWidth: 200, lineCap: .butt, lineJoin: .bevel, miterLimit: 1, dash: [100, 20], dashPhase: 10))
                        .rotationEffect(Angle(degrees: phase))
//                        .clipShape(RoundedRectangle(cornerRadius: 36))
                        .frame(width: contentZone.width * 1.2, height: contentZone.width * 1.2, alignment: .center)
                        .offset(x: contentZone.width * 0.5, y: contentZone.width * 0.6)
//                        .foregroundColor(.blue)
                }
            }
        }
        .onAppear() {
            withAnimation(Animation.easeInOut(duration: 2).delay(0.25)) {
                self.phase = 0
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
