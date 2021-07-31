//
//  StatCaptionView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 31.07.2021.
//

import SwiftUI

struct StatCaptionView: View {
    
    let caption: String
    
    var body: some View {
        Text(caption)
            .foregroundColor(.white)
            .font(.callout)
            .fontWeight(.bold)
            .padding(.top, 40)
            .padding(.bottom, 12)
    }
}

struct StatCaptionView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 4) {
                StatCaptionView(caption: "Color QUIZ")
                StatItemView(caption: "Collected Соlor Coins", value: "1807")
                StatItemView(caption: "Guessed unique colors", value: "54")
                StatItemView(caption: "Played games", value: "87")
            }
            .frame(width: UIScreen.main.bounds.width * 0.6, alignment: .center)
        }
    }
}
