//
//  MainMenuView.swift
//  Color Matching
//
//  Created by Alexey on 09.07.2021.
//

import SwiftUI

struct MainMenuView: View {
    
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
            ZStack {
                BackgroundView()
                
                VStack {
                    Spacer()
                    
                    Text("Color games collection")
                        .font(.title)
                        .fontWeight(.light)
                        .foregroundColor(ConvertColor(colorType: .hsba, value: (179, 73, 40, 1)))
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        NavigationLink(
                            destination: LearnAndQuizView()
                                .navigationBarBackButtonHidden(true)
                                .navigationBarTitleDisplayMode(.inline),
                                
                            label: {
                                MenuButtonView(text: "Color QUIZ", foregroundColor: ConvertColor(colorType: .hsba, value: (74, 67, 52, 1)))
                            })
                            
                        
                        MenuButtonView(text: "Warm VS Cold", foregroundColor: ConvertColor(colorType: .hsba, value: (188, 64, 56, 1)))
                        
                        MenuButtonView(text: "More games soon", noImage: true, foregroundColor: ConvertColor(colorType: .hsba, value: (74, 67, 52, 1)))
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            
//            LearnAndQuizView()
//                .navigationBarTitleDisplayMode(.inline)
////                .navigationTitle("Learn and Guess")
//                .navigationBarItems(leading:
//                    HStack {
//                        Button("< back") {
//
//                        }
//                        .font(.body)
//                        .foregroundColor(Color.init(hue: 0, saturation: 0, brightness: 0.34, opacity: 1))
//                    }
//                )
        }
    }
}

struct SingleModeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 8", "iPhone SE (1st generation)", "iPhone 12"], id: \.self) { device in
            MainMenuView()
                .previewDevice(PreviewDevice(stringLiteral: device))
                .previewDisplayName(device)
        }
    }
}
