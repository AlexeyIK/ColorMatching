//
//  ContentView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 05.07.2021.
//

import SwiftUI

struct DetailView: View {
    var skatepark: Skatepark
    
    var body: some View {
        VStack {
            
            MapView(coordinates: skatepark.locationCoodinate)
                .edgesIgnoringSafeArea(.top)
                .frame(height: 200)
            
            CircleImage(image: skatepark.image)
                .offset(y: -70)
                .padding(.bottom, -70)
        
            VStack(alignment: .leading, spacing: nil) {
                Text(skatepark.name)
                    .foregroundColor(.blue)
                    .font(.title)
                
                HStack {
                    Text(skatepark.area).font(.subheadline)
                    Spacer()
                    Text(skatepark.city).font(.subheadline)
                }
            }.padding()
            
            Spacer()
        }
        .navigationBarTitle(Text(skatepark.name), displayMode: .inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(skatepark: skateparkData[0])
    }
}
