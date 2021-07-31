//
//  StatsView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 31.07.2021.
//

import SwiftUI

struct StatsView: View {
    
    @FetchRequest(entity: PlayerStats.entity(), sortDescriptors: []) var playerStats: FetchedResults<PlayerStats>
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack() {
                Text("Stats")
                    .font(.largeTitle)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                    .kerning(6)
                    .padding(.bottom, 60)
                
                ScrollView(.vertical, showsIndicators: false) {
                    StatItemView(caption: "Collected Соlor Coins", value: String(playerStats[0].totalScore))
                    StatItemView(caption: "Guessed unique colors", value: String(playerStats[0].guessedColors))
                    
                    StatCaptionView(caption: "Color QUIZ")
                    StatItemView(caption: "Played games", value: String(playerStats[0].playedGamesCount))
                    StatItemView(caption: "Guessed colors:", value: String(playerStats[0].guessedColors))
                    StatItemView(caption: "Guessed unique colors", value: String(playerStats[0].guessedColors))
                }
                
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.8, alignment: .center)
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            StatsView()
        }
    }
}
