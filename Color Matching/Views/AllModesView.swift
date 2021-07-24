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
            DeckView().tabItem {
                Image(systemName: "square.stack.3d.down.right.fill").resizable().foregroundColor(.gray)
            }.tag(1)
            
            QuizGameView(hardnessLvl: .normal).tabItem {
                Image(systemName: "circle.fill").resizable().foregroundColor(.gray)
            }.tag(2)
            
            SimilarColorsView().tabItem {
                Image(systemName: "textformat.superscript").resizable().foregroundColor(.gray)
            }.tag(3)
            
            AnimationsTest().tabItem {
                Image(systemName: "text.justify").resizable().foregroundColor(.gray)
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
