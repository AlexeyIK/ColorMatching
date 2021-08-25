//
//  InfoView.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 26.08.2021.
//

import SwiftUI

struct InfoView: View {
    
    let screenSize: CGSize = UIScreen.main.bounds.size
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                Text("info-page-title")
                    .font(.title)
                    .fontWeight(.regular)
                    .foregroundColor(_globalMenuTitleColor)
//                    .padding(.top, 28)
                
                Spacer()
                
                Text("main-info-text")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                Text("additional-info-text")
                    .font(.caption)
                    .foregroundColor(.white)
                
                Text("credentials-text")
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 40)
                    .foregroundColor(ColorConvert(colorType: .hsba, value: (220, 8, 52, 1)))
                
                Spacer()
            }
            .frame(width: screenSize.width * 0.7, height: screenSize.height - 80, alignment: .center)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InfoView()
            InfoView()
                .environment(\.locale, Locale(identifier: "ru"))
        }
    }
}
