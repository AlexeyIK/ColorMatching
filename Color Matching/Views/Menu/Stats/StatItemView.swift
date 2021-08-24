//
//  StatItemView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 31.07.2021.
//

import SwiftUI

struct StatItemView: View {
    
    let caption: LocalizedStringKey
    let value: String
    
    var body: some View {
        HStack {
            Text(caption)
                .foregroundColor(.white)
                .font(.body)
                .fontWeight(.thin)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.white)
                .font(.body)
                .fontWeight(.bold)
        }
        .padding(.bottom, 4)
    }
}

func statCaption(str: LocalizedStringKey, separator: String) -> String {
    return "\(str)\(separator)"
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
            .frame(width: UIScreen.main.bounds.width * 0.65, alignment: .center)
        }
    }
}
