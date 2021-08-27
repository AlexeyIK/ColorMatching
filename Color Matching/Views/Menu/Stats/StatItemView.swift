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
    var flowerSign: Bool = false
    
    var body: some View {
        HStack {
            Text(caption)
                .foregroundColor(.white)
                .font(.body)
                .fontWeight(.thin)
            
            Spacer()
            
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .center)) {
                Text(value)
                    .foregroundColor(.white)
                    .font(.body)
                    .fontWeight(.bold)
            
                if flowerSign {
                    Image("iconColorCoin")
                        .resizable()
                        .frame(width: 18, height: 18, alignment: .center)
                        .offset(x: 22)
                }
            }
        }
        .padding(.bottom, 4)
        .padding(.horizontal, 22)
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
                StatItemView(caption: "Collected Соlor Coins:", value: "1807", flowerSign: true)
                StatItemView(caption: "Guessed unique colors:", value: "57", flowerSign: true)
                StatItemView(caption: "Played games:", value: "87")
            }
            .frame(width: UIScreen.main.bounds.width * 0.75, alignment: .center)
        }
    }
}
