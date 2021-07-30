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
            GeometryReader { geometry in
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
                            
                            MenuButtonView(text: "More games soon", noImage: true)
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            Image(systemName: "arrow.right.doc.on.clipboard")
                                .resizable()
                                .foregroundColor(.gray)
                                .frame(width: 40, height: 40, alignment: .topTrailing)
                                .padding()
                            
                            Spacer()
                        }
                    }
                
                    HStack(alignment: .center) {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(
                                                    colors: [
                                                        ConvertColor(colorType: .rgba, value: (0, 255, 127, 1)),
                                                        ConvertColor(colorType: .rgba, value: (70, 63, 250, 1)),
                                                        ConvertColor(colorType: .rgba, value: (255, 0, 255, 1))
                                                    ]),
                                                 startPoint: .top,
                                                 endPoint: .bottom))
                            .frame(width: 5, alignment: .center)
                        
                        Spacer()
                        
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(
                                                    colors: [
                                                        ConvertColor(colorType: .rgba, value: (255, 0, 107, 1)),
                                                        ConvertColor(colorType: .rgba, value: (255, 164, 2, 1)),
                                                        ConvertColor(colorType: .rgba, value: (69, 215, 0, 1))
                                                    ]),
                                                 startPoint: .top,
                                                 endPoint: .bottom))
                            .frame(width: 5, alignment: .center)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
            }
            .navigationBarHidden(true)
            .statusBar(hidden: true)
        }
    }
}

struct SingleModeView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (1st generation)", "iPhone 8", "iPhone 12"], id: \.self) { device in
            MainMenuView()
                .previewDevice(PreviewDevice(stringLiteral: device))
                .previewDisplayName(device)
        }
    }
}
