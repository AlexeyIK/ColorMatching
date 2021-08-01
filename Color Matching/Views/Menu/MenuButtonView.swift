//
//  MenuButtonView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 30.07.2021.
//

import SwiftUI

struct MenuButtonView: View {
    
    var text: String = ""
    var imageName: String = ""
    var noImage: Bool = false
    var foregroundColor: Color = .gray
    
    var body: some View {
        ZStack(alignment: noImage ? .center : .leading) {
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.init(hue: 0, saturation: 0, brightness: 0.16, opacity: 1))
                .frame(height: 58, alignment: .center)
            
            HStack(spacing: 0) {
                if (!noImage) {
                    if (imageName == "") {
                        Rectangle()
                            .frame(width: 100, height: 100, alignment: .center)
                            .padding(.leading, 16)
                            .foregroundColor(.gray)
                    } else {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                            .frame(width: 90, height: 110, alignment: .center)
                            .padding(.leading, 16)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                
                Text(text)
                    .foregroundColor(foregroundColor)
                    .font(.title2)
                    .fontWeight(noImage ? .regular : .heavy)
                    .layoutPriority(1)
                    .lineLimit(1)
                    .padding(.leading, noImage ? 20 : 0)
                
                if (!noImage) {
                    Spacer()
                    
                    Image(systemName: "chevron.right").scaleEffect(0.9)
                        .foregroundColor(foregroundColor)
                        .font(.title2)
                        .padding(.trailing, 5)
                }
                    
            }
            .frame(height: 80, alignment: .center)
        }
        .padding(.horizontal, 20)
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView(text: "More mini-games soon", imageName: "iconColdVsWarm")
    }
}
