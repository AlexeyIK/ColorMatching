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
                    .padding(.bottom, 20)
//                    .padding(.top, 28)
                
                Spacer()
                
                ScrollView(.vertical, showsIndicators: false) {
                    Text("main-info-text")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    
                    Text("additional-info-text")
                        .font(.footnote)
                        .foregroundColor(.white)
                    
                    Rectangle()
                        .fill(Color.init(hue: 0, saturation: 0, brightness: 0.25))
                        .frame(width: 80, height: 1, alignment: .center)
                        .padding(.top, 20)
                    
                    Text("credentials-text")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(ColorConvert(colorType: .hsba, value: (220, 8, 52, 1)))
                }
                
                Spacer()
            }
            .frame(width: screenSize.width * 0.7, height: screenSize.height - 150, alignment: .center)
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
