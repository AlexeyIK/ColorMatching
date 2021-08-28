//
//  MainMenuView.swift
//  Color Matching
//
//  Created by Alexey on 09.07.2021.
//

import SwiftUI

enum MenuTabItem {
    case info
    case mainmenu
    case stats
    case settings
}

class MenuState: ObservableObject {
    
    @Published var isMenuActive: Bool = true
    @Published var selectedTab: MenuTabItem = .mainmenu
}

struct MainMenuView: View {
    
    struct TabItem: Hashable {
        let tab: MenuTabItem
        let previewImg: String
    }
    
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
    
    let screenSize = UIScreen.main.bounds
    let tabButtonsSize: CGFloat = 54
    let selectedDescaleFactor: CGFloat = 0.6
    let hapticImpact = UISelectionFeedbackGenerator()
    
    let tabButtons: [TabItem] = [TabItem(tab: .info, previewImg: "questionmark.circle.fill"), TabItem(tab: .mainmenu, previewImg: "play.circle.fill"), TabItem(tab: .stats, previewImg: "flag.circle.fill"), TabItem(tab: .settings, previewImg: "gearshape.fill")]
    
    @StateObject var menuState: MenuState = MenuState()
    @StateObject var settingsState: SettingsState = SettingsState()
    
    @State var linesOffset: CGFloat = 0.0
    @State var hueRotation: Double = 0.0
    
    var body: some View {
        ZStack {
            NavigationView {
                GeometryReader { geometry in
                    switch menuState.selectedTab {
                    case .info:
                        InfoView()
                    case .mainmenu:
                        VStack {
                            Text("main-menu-title")
                                .font(.title)
                                .fontWeight(.regular)
                                .foregroundColor(_globalMenuTitleColor)
                                .padding(.top, 28)
                            
                            Spacer()
                            
                            VStack(spacing: 0) {
                                NavigationLink(
                                    destination: ColorQuizMainView()
                                        .navigationBarBackButtonHidden(true)
                                        .navigationBarTitleDisplayMode(.inline)
                                        .environmentObject(menuState)
                                        .environmentObject(settingsState), // глобальные настройки
                                        
                                    label: {
                                        MenuButtonView(text: "color-quiz", imageName: "iconColorQUIZ", foregroundColor: ColorConvert(colorType: .hsba, value: (302, 67, 85, 1)))
                                    })
                                
                                NavigationLink(
                                    destination: LearnAndQuizView()
                                        .navigationBarBackButtonHidden(true)
                                        .navigationBarTitleDisplayMode(.inline)
                                        .environmentObject(menuState)
                                        .environmentObject(settingsState), // глобальные настройки
                                        
                                    label: {
                                        MenuButtonView(text: "name-quiz", imageName: "iconNameQIUZ", foregroundColor: ColorConvert(colorType: .hsba, value: (74, 67, 52, 1)))
                                    })
                                
                                MenuButtonView(text: "warm-vs-cold", imageName: "iconColdVsWarm", foregroundColor: ColorConvert(colorType: .hsba, value: (188, 64, 56, 1))).saturation(0).colorMultiply(Color.init(hue: 0, saturation: 0, brightness: 0.75))
                                
                                Text("more-games-soon")
                                    .padding(.top, 20)
                                    .foregroundColor(Color.init(hue: 0, saturation: 0, brightness: 0.74))
                                    .font(.callout)
                            }
                            
                            Spacer()
                        }
                        .animation(.none)
                        .frame(width: geometry.size.width, height: geometry.size.height - 70, alignment: .top)
                    case .stats:
                        StatsView()
                    case .settings:
                        SettingsView()
                            .environmentObject(settingsState)
                    }
                }
                .transition(.identity)
                .navigationBarHidden(true)
                .background(BackgroundView())
            }
            
            // Tabbar
            if menuState.isMenuActive {
                VStack {
                    Spacer()
                   
                    HStack(alignment: .bottom, spacing: screenSize.width / 12) {
                        ForEach(tabButtons, id: \.self) { button in
                            Button(action: {
                                menuState.selectedTab = button.tab
                                if settingsState.tactileFeedback {
                                    hapticImpact.selectionChanged()
                                }
                            }, label: {
                                VStack(spacing: 8) {
                                    Image(systemName: button.previewImg)
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(width: tabButtonsSize, height: tabButtonsSize)
                                        .foregroundColor(menuState.selectedTab == button.tab ? _globalMenuSelectedColor : _globalMenuUnselectedColor)
                                        .scaleEffect(menuState.selectedTab == button.tab ? 1 : selectedDescaleFactor)
                                        .animation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0))
                                }
                            })
                        }
                    }
                    .padding(.bottom, 10)
                    .transition(.move(edge: .leading))
                }
                .frame(width: UIScreen.main.bounds.width - 40, alignment: .center)
                .transition(.move(edge: .leading))
                .animation(.easeInOut)
            }
            
            if menuState.isMenuActive {
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
                        .frame(width: 3, alignment: .center)
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
                        .frame(width: 3, alignment: .center)
                        .animation(repeatingLinesAnimation, value: hueRotation)
                }
                .ignoresSafeArea()
    //                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                .onAppear() {
                    self.hueRotation = 3600
                }
            }
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
