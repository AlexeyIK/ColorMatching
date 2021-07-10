//
//  RowView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 09.07.2021.
//

import SwiftUI

struct RowView: View {
    
    var skatepark: Skatepark
    
    var body: some View {
        HStack {
            skatepark.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(skatepark.name)
            Spacer()
            if skatepark.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RowView(skatepark: skateparkData[0])
            RowView(skatepark: skateparkData[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
