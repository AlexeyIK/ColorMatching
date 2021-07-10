//
//  ListView.swift
//  Color Matching
//
//  Created by Alexey on 10.07.2021.
//

import SwiftUI

struct ListView: View {
    
    @State var showFavoriteSkateparks: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                
                Toggle(isOn: $showFavoriteSkateparks) {
                    Text("Show favorites")
                }
                
                ForEach(skateparkData) { skatepark in
                    if (!self.showFavoriteSkateparks || skatepark.isFavorite) {
                        NavigationLink(
                            destination: DetailView(skatepark: skatepark)) {
                            RowView(skatepark: skatepark)
                        }
                    }
            }
            .navigationBarTitle(Text("Skateparks"))
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
//        ForEach(["iPhone X", "iPhone 8"], id: \.self) { deviceName in
//            ListView()
//                .previewDevice(PreviewDevice(rawValue: deviceName))
//                .previewDisplayName(deviceName)
//        }
        
        ListView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
    }
}
