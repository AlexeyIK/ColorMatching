//
//  SingleModeView.swift
//  Color Matching
//
//  Created by Alexey on 09.07.2021.
//

import SwiftUI

struct FirstModeView: View {
    var body: some View {
        TabView(selection: .constant(0)) {
            HStack() {
                Rectangle()
                    .frame(width: 200, height: 300, alignment: .center)
                    .cornerRadius(20)
                    .foregroundColor(.green)
                    .offset(x: -45)
                    .scaleEffect(0.9)
                Spacer()
                Rectangle()
                    .frame(width: 200, height: 300, alignment: .center)
                    .cornerRadius(20)
                    .foregroundColor(.yellow)
                Spacer()
                Rectangle()
                    .frame(width: 200, height: 300, alignment: .center)
                    .cornerRadius(20)
                    .foregroundColor(.red)
                    .offset(x: 45)
                    .scaleEffect(0.9)
                Spacer()
            }.tabItem {
                Image(systemName: "capsule").resizable().foregroundColor(.gray)
//                Text("Mode 1")
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
        FirstModeView()
            .previewDevice(PreviewDevice(stringLiteral: "iPhone X"))
    }
}
