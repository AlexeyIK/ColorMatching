//
//  SingleModeView.swift
//  Color Matching
//
//  Created by Alexey on 09.07.2021.
//

import SwiftUI

struct AllModesView: View {
    
    var body: some View {
        TabView(selection: .constant(0)) {
            DeckView()
                .tabItem {
                Image(systemName: "square.stack.3d.down.right.fill").resizable().foregroundColor(.gray)
                }.tag(1)
            
            SwipeView().tabItem {
                Image(systemName: "circle.fill").resizable().foregroundColor(.gray)
            }.tag(2)
            
            Text("Mode 3").tabItem {
                Image(systemName: "textformat.superscript").resizable().foregroundColor(.gray)
            }.tag(3)
            
            Text("Mode 4").tabItem {
                Image(systemName: "text.justify").resizable().foregroundColor(.gray)
            }.tag(4)
        }
    }
}

struct SingleModeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 8", "iPhone Xs"], id: \.self) { device in
            AllModesView()
                .previewDevice(PreviewDevice(stringLiteral: device))
                .previewDisplayName(device)
        }
    }
}
