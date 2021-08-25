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
            
            GeometryReader { geometry in
                HStack {
                    Spacer()
                    
                    VStack {
                        Text("info-page-title")
                            .font(.title)
                            .fontWeight(.regular)
                            .foregroundColor(_globalMenuTitleColor)
                            .padding(.bottom, 20)
                            .padding(.top, 28)
                        
                        Spacer()
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            Text("main-info-text")
                                .font(.callout)
                                .foregroundColor(.white)
                            
//                            Text("additional-info-text")
//                                .padding(.top, 16)
//                                .font(.footnote)
//                                .foregroundColor(.white)
                            
                            Rectangle()
                                .fill(Color.init(hue: 0, saturation: 0, brightness: 0.25))
                                .frame(width: 80, height: 1, alignment: .center)
                                .padding(.bottom, 10)
                            
                            Text("credentials-text")
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundColor(ColorConvert(colorType: .hsba, value: (220, 8, 52, 1)))
                                .frame(width: geometry.size.width * 0.72, alignment: .leading)
                        }
                        
                        Spacer()
                    }
                    .frame(width: geometry.size.width * 0.72, height: geometry.size.height - 70, alignment: .top)
                    
                    Spacer()
                }
            }
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
