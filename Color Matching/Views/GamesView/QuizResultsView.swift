//
//  QuizResultsView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 01.08.2021.
//

import SwiftUI

struct QuizResultsView: View {
    
    let scoreEarned: Int
    let strikeMultiplier: Float
    let strikeBonus: Int
    
    @State var hueAngle: Double = 0.0
    
    var repeatingLinesAnimation: Animation {
        Animation
            .linear(duration: 1)
            .repeatForever()
    }
    
    var body: some View {
        Group {
            VStack(alignment: .center) {
                Text("\(scoreEarned > 0 ? "+" : "")\(scoreEarned - strikeBonus) CC")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                
                if (strikeBonus > 0) {
                    Text("Strike bonus: x" + String(strikeMultiplier))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                    
                    Text("= \(scoreEarned) CC")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .shadow(color: Color.black.opacity(0.3), radius: 8, x: -1, y: -1)
                }
                
            }
            .padding()
            .rainbowOverlay()
            .hueRotation(Angle(degrees: hueAngle))
            .animation(repeatingLinesAnimation, value: hueAngle)
            .onAppear() {
                self.hueAngle = 360
            }
        }
//        .transition(.scale)
//        .animation(Animation.easeInOut(duration: 0.5).delay(1))
    }
}

struct QuizResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            QuizResultsView(scoreEarned: 512, strikeMultiplier: 1.5, strikeBonus: 256)
        }
        .ignoresSafeArea()
    }
}

extension View {
    func rainbowOverlay() -> some View {
        self
//            .overlay(LinearGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), startPoint: .leading, endPoint: .trailing).scaleEffect(1.5))
            .overlay(AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center))
            .brightness(0.3)
            .mask(self.blur(radius: 8))
            .overlay(self.opacity(0.9))
    }
}
