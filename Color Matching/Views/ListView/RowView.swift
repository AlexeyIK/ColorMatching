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
        }
        .padding()
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(skatepark: skateparkData[0])
    }
}
