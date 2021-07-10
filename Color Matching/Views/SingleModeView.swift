//
//  SingleModeView.swift
//  Color Matching
//
//  Created by Alexey on 09.07.2021.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Rectangle().scaledToFill().foregroundColor(.gray)
            .edgesIgnoringSafeArea(.all)
    }
}

struct SingleModeView: View {
    
    var backgroundView = BackgroundView()
    
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
            }.tag(1)
            
            Text("Tab Content 2").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/
            }.tag(2)
            
        }.background(backgroundView)
    }
}

struct SingleModeView_Previews: PreviewProvider {
    static var previews: some View {
        SingleModeView()
    }
}
