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
    
    var repeatingLinesAnimation: Animation {
        Animation
            .linear(duration: 30)
            .repeatForever()
    }
    
    @Environment(\.managedObjectContext) var dataStorage
    @FetchRequest(entity: OverallStats.entity(), sortDescriptors: []) var overallStats: FetchedResults<OverallStats>
    @FetchRequest(entity: ColorQuizStats.entity(), sortDescriptors: []) var colorQuizStats: FetchedResults<ColorQuizStats>
    
    @State var linesOffset: CGFloat = 0.0
    @State var hueRotation: Double = 0.0
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    BackgroundView()
                        .animation(.none)
                    
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
                                    MenuButtonView(text: "Color QUIZ", imageName: "iconColorQUIZ", foregroundColor: ConvertColor(colorType: .hsba, value: (74, 67, 52, 1)))
                                })
                                
                            
                            MenuButtonView(text: "Warm VS Cold", imageName: "iconColdVsWarm", foregroundColor: ConvertColor(colorType: .hsba, value: (188, 64, 56, 1)))
                            
                            MenuButtonView(text: "More games soon", noImage: true)
                        }
                        .offset(y: -geometry.size.height * 0.05)
                        
                        Spacer()
                    }
                    .animation(.none)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(
                            destination: StatsView()
                                .navigationBarBackButtonHidden(true)
                                .navigationBarTitleDisplayMode(.inline),
                            
                            label: {
                            VStack {
                                ZStack {
                                    Image(systemName: "hexagon")
                                        .resizable()
                                        .aspectRatio(0.9, contentMode: .fit)
                                        .foregroundColor(ConvertColor(colorType: .rgba, value: (41, 41, 41, 1)))
                                    
                                    Circle()
                                        .strokeBorder(lineWidth: 2, antialiased: true)
                                        .foregroundColor(ConvertColor(colorType: .rgba, value: (77, 77, 77, 1)))
                                        .scaleEffect(0.7)
                                }
                                .frame(width: 50, height: 50, alignment: .topTrailing)
                                .padding(.all, 10)
                                
                                Spacer()
                            }
                        })
                    }
                    .animation(.none)
                
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
                            .hueRotation(Angle(degrees: hueRotation))
                            .transition(.identity)
                            .frame(width: 6, alignment: .center)
                            .animation(repeatingLinesAnimation, value: hueRotation)
                        
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
                            .hueRotation(Angle(degrees: -hueRotation))
                            .transition(.identity)
                            .frame(width: 6, alignment: .center)
                            .animation(repeatingLinesAnimation, value: hueRotation)
                    }
                    .ignoresSafeArea()
//                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .onAppear() {
                        self.hueRotation = 3600
                    }
                }
            }
            .transition(.identity)
            .navigationBarHidden(true)
        }
        .onAppear() {
            if overallStats.count == 0 {
                _ = CoreDataManager.shared.createOverallStatsTable()
            }
            if colorQuizStats.count == 0 {
                _ = CoreDataManager.shared.createColorQuizStatsTable()
            }
            
            CoreDataManager.shared.showAllReadings()
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
