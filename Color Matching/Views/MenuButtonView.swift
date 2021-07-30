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
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.init(hue: 0, saturation: 0, brightness: 0.16, opacity: 1))
                .frame(height: 58, alignment: .center)
            
            HStack(spacing: 4) {
                if (!noImage) {
                    if (imageName == "") {
                        Rectangle()
                            .frame(width: 84, height: 84, alignment: .center)
                            .padding(.leading, 16)
                            .foregroundColor(.gray)
                    } else {
                        Image(imageName)
                            .resizable()
                            .frame(width: 84, height: 84, alignment: .center)
                            .padding(.leading, 16)
                            .foregroundColor(.gray)
                    }
                }
                
                Text(text)
                    .foregroundColor(foregroundColor)
                    .font(.title2)
                    .fontWeight(noImage ? .regular : .heavy)
                    .layoutPriority(1)
                    .lineLimit(1)
                    .padding(.leading, noImage ? 20 : 0)
                    .frame(width: noImage ? 280 : 160, alignment: .center)
                
                if (!noImage) {
                    Image(systemName: "arrow.right.circle").scaleEffect(0.9)
//                    Text(">")
                        .foregroundColor(foregroundColor)
                        .font(.title)
                        .padding(.trailing, 5)
                }
                    
            }
        }
        .padding(.horizontal, 30)
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView(text: "More mini-games soon")
    }
}
