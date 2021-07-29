//
//  SingleModeView.swift
//  Color Matching
//
//  Created by Alexey on 09.07.2021.
//

import SwiftUI

struct AllModesView: View {
    
    init() {
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().barStyle = .default
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    var body: some View {
        
        NavigationView {
            LearnAndQuizView()
                .navigationBarTitleDisplayMode(.inline)
//                .navigationTitle("Learn and Guess")
                .navigationBarItems(leading:
                    HStack {
                        Button("< back") {
                            
                        }
                        .font(.body)
                        .foregroundColor(Color.init(hue: 0, saturation: 0, brightness: 0.34, opacity: 1))
                    }
                )
                
        }
        
//        TabView(selection: .constant(0)) {
//            LearnAndQuizView().tabItem {
//                Image(systemName: "square.stack.3d.down.right.fill").resizable().foregroundColor(.gray)
//            }.tag(1)
//
//            SimilarColorsView().tabItem {
//                Image(systemName: "square.stack.3d.up.badge.a.fill").resizable().foregroundColor(.gray)
//            }.tag(2)
//
//            SimilarColorsView().tabItem {
//                Image(systemName: "rectangle.split.3x1").resizable().foregroundColor(.gray)
//            }.tag(3)
//
//            AnimationsTest().tabItem {
//                Image(systemName: "square.stack.3d.forward.dottedline").resizable().foregroundColor(.gray)
//            }.tag(4)
//        }
//        .accentColor(_globalTabBarBackground)
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
