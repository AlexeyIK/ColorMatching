//
//  MenuButton.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 30.07.2021.
//

import SwiftUI

struct MenuButtonView: View {
    
    var text: String = ""
    var imageName: String? = nil
    var foregroundColor: Color = .gray
    
    var body: some View {
        Button
        ZStack(alignment: .leading) {
            if imageName == nil {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.init(hue: 0, saturation: 0, brightness: 0.16, opacity: 1))
                    .frame(height: 58, alignment: .center)
            }
            else {
                Image(imageName!)
                    .resizable()
                    .frame(height: 58, alignment: .center)
            }
            
            HStack( spacing: 5) {
                Rectangle()
                    .frame(width: 90, height: 80, alignment: .center)
                    .padding(.leading, 20)
                    .foregroundColor(.gray)
                
                Text(text)
                    .foregroundColor(foregroundColor)
                    .font(.title2)
                    .layoutPriority(1)
                    .lineLimit(1)
                    .frame(width: 170, alignment: .center)
                
                Text(">")
                    .foregroundColor(foregroundColor)
                    .font(.title)
                    
            }
        }
        .padding(.horizontal, 30)
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView(text: "QUIZ")
    }
}
