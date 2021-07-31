//
//  StatsView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 31.07.2021.
//

import SwiftUI

struct StatsView: View {
    var body: some View {
        ZStack {
            VStack() {
                Text("Stats")
                    .font(.largeTitle)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                    .kerning(6)
                
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        Text("Collected Соlor Coins:").foregroundColor(.white).fontWeight(.thin)
                        Spacer()
                        Text("54").foregroundColor(.white).fontWeight(.bold)
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.6, alignment: .center)
                
            }
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
