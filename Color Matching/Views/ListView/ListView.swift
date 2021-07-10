//
//  ListView.swift
//  Color Matching
//
//  Created by Alexey on 10.07.2021.
//

import SwiftUI

struct ListView: View {
    var body: some View {
        NavigationView {
            List(skateparkData) { skatepark in
                NavigationLink(
                    destination: DetailView(skatepark: skatepark)) {
                    RowView(skatepark: skatepark)
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
