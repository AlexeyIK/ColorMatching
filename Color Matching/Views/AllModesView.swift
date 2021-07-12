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
            SwipeView().padding()
                .tabItem {
                Image(systemName: "square.stack.3d.down.right.fill").resizable().foregroundColor(.gray)
            }.tag(1)
//                .background(Color.gray)
            
            Text("Mode 2").tabItem {
                Image(systemName: "circle.fill").resizable().foregroundColor(.gray)
//                Text("Mode 2")
            }.tag(2)
            
            Text("Mode 3").tabItem {
                Image(systemName: "textformat.superscript").resizable().foregroundColor(.gray)
//                Text("Mode 2")
            }.tag(3)
            
            Text("Mode 4").tabItem {
                Image(systemName: "text.justify").resizable().foregroundColor(.gray)
//                Text("Mode 4")
            }.tag(4)
        }
    }
}

struct SingleModeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 8", "iPhone X"], id: \.self) { device in
            AllModesView()
                .previewDevice(PreviewDevice(stringLiteral: device))
                .previewDisplayName(device)
        }
    }
}
