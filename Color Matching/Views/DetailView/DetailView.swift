//
//  ContentView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 05.07.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            
            MapView()
                .edgesIgnoringSafeArea(.top)
                .frame(height: 200)
            
            CircleImage()
                .offset(y: -60)
                .padding(.bottom, -60)
        
            VStack(alignment: .leading, spacing: nil) {
                Text("Color matcher")
                    .foregroundColor(.blue)
                    .font(.title)
                
                HStack {
                    Text("Area").font(.subheadline)
                    Spacer()
                    Text("West London").font(.subheadline)
                }
            }.padding()
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
