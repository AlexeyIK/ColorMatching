//
//  CircleImage.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 08.07.2021.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("color-table-saturation")
            .resizable()
            .frame(width: 100.0, height: 100.0)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
            
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
