//
//  CircleImage.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 08.07.2021.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    
    var body: some View {
        image.resizable()
            .frame(width: 120.0, height: 120.0)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
            
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("acton_skpark"))
    }
}
