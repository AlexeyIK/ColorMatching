//
//  StatItemView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 31.07.2021.
//

import SwiftUI

struct StatItemView: View {
    
    let caption: String
    let value: String
    
    var body: some View {
        HStack {
            Text(caption + ":")
                .foregroundColor(.white)
                .font(.callout)
                .fontWeight(.thin)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.white)
                .font(.callout)
                .fontWeight(.bold)
        }
    }
}

struct StatItemView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 4) {
                StatItemView(caption: "Collected Соlor Coins", value: "1807")
                StatItemView(caption: "Guessed unique colors", value: "54")
                StatItemView(caption: "Played games", value: "87")
            }
            .frame(width: UIScreen.main.bounds.width * 0.6, alignment: .center)
        }
    }
}
