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
    @FetchRequest(entity: NameQuizStats.entity(), sortDescriptors: []) var nameQuizStats: FetchedResults<NameQuizStats>
    @FetchRequest(entity: ColorQuizStats.entity(), sortDescriptors: []) var colorQuizStats: FetchedResults<ColorQuizStats>
    
    @State var linesOffset: CGFloat = 0.0
    @State var hueRotation: Double = 0.0
    
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    BackgroundView()
                        .animation(.none)
                    
                    // кнопка статистики
                    HStack {
                        Spacer()
                        
                        VStack {
                            NavigationLink(
                                destination: StatsView()
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarTitleDisplayMode(.inline),
                                
                                label: {
                                    ZStack {
                                        Image("iconStats")
                                            .resizable()
                                    }
                                    .frame(width: 50, height: 50, alignment: .topTrailing)
                                    .padding(.all, 10)
                            })
                            
                            Spacer()
                        }
                    }
                    .animation(.none)
                    
                    VStack {
                        Spacer()
                        
                        Text("main-menu-title")
                            .font(.title)
                            .fontWeight(.light)
                            .foregroundColor(ColorConvert(colorType: .hsba, value: (179, 73, 40, 1)))
                        
                        Spacer()
                        
                        VStack(spacing: 0) {
                            NavigationLink(
                                destination: ColorQuizMainView()
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarTitleDisplayMode(.inline)
                                    .transition(.identity),
                                    
                                label: {
                                    MenuButtonView(text: "color-quiz", imageName: "iconColorQUIZ", foregroundColor: ColorConvert(colorType: .hsba, value: (74, 67, 52, 1)))
                                })
                            
                            NavigationLink(
                                destination: LearnAndQuizView()
                                    .navigationBarBackButtonHidden(true)
                                    .navigationBarTitleDisplayMode(.inline),
                                    
                                label: {
                                    MenuButtonView(text: "name-quiz", imageName: "iconNameQIUZ", foregroundColor: ColorConvert(colorType: .hsba, value: (74, 67, 52, 1)))
                                })
                            
                            MenuButtonView(text: "warm-vs-cold", imageName: "iconColdVsWarm", foregroundColor: ColorConvert(colorType: .hsba, value: (188, 64, 56, 1))).saturation(0).colorMultiply(Color.init(hue: 0, saturation: 0, brightness: 0.75))
                            
                            MenuButtonView(text: "more-games-soon", noImage: true)
                        }
                        .offset(y: -geometry.size.height * 0.05)
                        
                        Spacer()
                    }
                    .padding(.top, 25)
                    .animation(.none)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                
                    // цветные полоски по краям
                    HStack(alignment: .center) {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(
                                                    colors: [
                                                        ColorConvert(colorType: .rgba, value: (0, 255, 127, 1)),
                                                        ColorConvert(colorType: .rgba, value: (70, 63, 250, 1)),
                                                        ColorConvert(colorType: .rgba, value: (255, 0, 255, 1))
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
                                                        ColorConvert(colorType: .rgba, value: (255, 0, 107, 1)),
                                                        ColorConvert(colorType: .rgba, value: (255, 164, 2, 1)),
                                                        ColorConvert(colorType: .rgba, value: (69, 215, 0, 1))
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
            if nameQuizStats.count == 0 {
                _ = NameQuizDataManager.shared.createStatsTable()
            }
            if colorQuizStats.count == 0 {
                _ = ColorQuizDataManager.shared.createStatsTable()
            }

            CoreDataManager.shared.showAllReadings()
        }
    }
}

struct SingleModeView_Previews: PreviewProvider {
    static var previews: some View {
//        ForEach(["iPhone SE (1st generation)", "iPhone 8", "iPhone 12"], id: \.self) { device in
        Group {
            MainMenuView()
                .environment(\.locale, Locale(identifier: "en"))
            MainMenuView()
                .environment(\.locale, Locale(identifier: "ru"))
        }
//                .previewDevice(PreviewDevice(stringLiteral: device))
//                .previewDisplayName(device)
//        }
    }
}
