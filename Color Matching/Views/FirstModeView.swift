//
//  SingleModeView.swift
//  Color Matching
//
//  Created by Alexey on 09.07.2021.
//

import SwiftUI

struct FirstModeView: View {
    var body: some View {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            HStack {
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
                Text("Mode 1")
            }.tag(1).background(Color.gray.scaledToFill().ignoresSafeArea())
            
            Text("Mode 2").tabItem {
                Text("Mode 2")
            }.tag(2).background(Color.gray.scaledToFill().ignoresSafeArea())
            
            Text("Mode 3").tabItem {
                Text("Mode 2")
            }.tag(3).background(Color.gray.scaledToFill().ignoresSafeArea())
            
            Text("Mode 4").tabItem {
                Text("Mode 4")
            }.tag(4).background(Color.gray.scaledToFill().ignoresSafeArea())
            
        }
    }
}

struct SingleModeView_Previews: PreviewProvider {
    static var previews: some View {
        FirstModeView()
            .previewDevice(PreviewDevice(stringLiteral: "iPhone X"))
    }
}
