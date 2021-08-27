//
//  ScorePointView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 31.07.2021.
//

import SwiftUI

struct ScorePointView: View {
    
    let score: Int
    let isCorrect: Bool
    
    var body: some View {
        HStack {
            Text(score >= 0 ? "+\(score)" : "\(score)")
                .font(.title)
                .foregroundColor(isCorrect ? .white : .red)
                .fontWeight(.bold)
                .transition(.identity)
                .shadow(color: .gray, radius: 10, x: 0, y: 0)
                .transition(.identity)
            
            Image("iconColorCoin")
                .resizable()
                .frame(width: 26, height: 26, alignment: .center)
                .offset(x: -4, y: 0)
        }
    }
}

struct ScorePointView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            ScorePointView(score: 12, isCorrect: true)
        }
    }
}
