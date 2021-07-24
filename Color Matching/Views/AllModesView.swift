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
            LearnAndQuizView().tabItem {
                Image(systemName: "square.stack.3d.down.right.fill").resizable().foregroundColor(.gray)
            }.tag(1)
            
            DeckView().tabItem {
                Image(systemName: "square.stack.3d.up.badge.a.fill").resizable().foregroundColor(.gray)
            }.tag(2)
            
            SimilarColorsView().tabItem {
                Image(systemName: "rectangle.split.3x1").resizable().foregroundColor(.gray)
            }.tag(3)
            
            AnimationsTest().tabItem {
                Image(systemName: "square.stack.3d.forward.dottedline").resizable().foregroundColor(.gray)
            }.tag(4)
        }
        .accentColor(_globalTabBarBackground)
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
