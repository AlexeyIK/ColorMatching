//
//  MenuButtonView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 30.07.2021.
//

import SwiftUI

struct MenuButtonView: View {
    
    var text: LocalizedStringKey = ""
    var imageName: String = ""
    var noImage: Bool = false
    var foregroundColor: Color = .gray
    
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        ZStack(alignment: noImage ? .center : .leading) {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.init(hue: 0, saturation: 0, brightness: 0.16, opacity: 1))
                .frame(height: 48, alignment: .center)
            
            HStack() {
                if (!noImage) {
                    if (imageName == "") {
                        Rectangle()
                            .frame(width: 100, height: 100, alignment: .center)
                            .padding(.leading, 5)
                            .foregroundColor(.gray)
                    } else {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .frame(width: 100, height: 100, alignment: .center)
                            .padding(.leading, 5)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                
                Text(text)
                    .foregroundColor(foregroundColor)
                    .font(screenSize.width >= 340 || Locale.current.languageCode == "en" ? .title3 : .headline)
                    .fontWeight(noImage ? .regular : .heavy)
                    .layoutPriority(1)
                    .lineLimit(1)
                    .padding(.leading, noImage ? 20 : 0)
                
                if (!noImage) {
                    Spacer()
                    
                    Image(systemName: "chevron.right").scaleEffect(0.9)
                        .foregroundColor(foregroundColor)
                        .font(.title2)
                        .padding(.trailing, 6)
                }
                    
            }
            .frame(height: 80, alignment: .center)
        }
        .padding(.horizontal,  screenSize.width >= 380 ? 32 : 20)
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView(text: "More mini-games soon", imageName: "iconColdVsWarm")
    }
}
