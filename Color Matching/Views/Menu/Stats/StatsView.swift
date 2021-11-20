//
//  StatsView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 31.07.2021.
//

import SwiftUI

struct StatsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest(entity: OverallStats.entity(), sortDescriptors: []) var playerStats: FetchedResults<OverallStats>
    @FetchRequest(entity: ColorQuizStats.entity(), sortDescriptors: []) var colorQuizStats: FetchedResults<ColorQuizStats>
    @FetchRequest(entity: NameQuizStats.entity(), sortDescriptors: []) var nameQuizStats: FetchedResults<NameQuizStats>
    @FetchRequest(entity: ViewedColor.entity(), sortDescriptors: [], predicate: NSPredicate(format: "isGuessed == true")) var viewedColors: FetchedResults<ViewedColor>
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    Text("Stats")
                        .font(.title)
                        .fontWeight(.regular)
                        .foregroundColor(_globalMenuTitleColor)
    //                    .kerning(6)
                        .padding(.bottom, 60)
                        .padding(.top, 28)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        Group {
                            StatItemView(caption: "Collected Соlor Coins:", value: String(playerStats[0].totalScore), flowerSign: true)
                            StatItemView(caption: "Last game Color Coins:", value: String(playerStats[0].lastGameScore), flowerSign: true)
                            StatItemView(caption: "Total games finished:", value: String(playerStats[0].totalFinishedGames))
                            StatItemView(caption: "Guessed unique colors:", value: String(viewedColors.count))
                        }
                        
                        Group {
                            StatCaptionView(caption: "color-quiz")
                            StatItemView(caption: "Finished games:", value: String(colorQuizStats[0].finishedGames))
                            StatItemView(caption: "Guessed colors:", value: String(colorQuizStats[0].colorsGuessed))
                            StatItemView(caption: "Color Strikes:", value: String(colorQuizStats[0].strikesCount))
                            StatItemView(caption: "Best Strike:", value: String(colorQuizStats[0].bestStrike))
                            StatItemView(caption: "Easy finished:", value: String(colorQuizStats[0].easyCount))
                            StatItemView(caption: "Normal finished:", value: String(colorQuizStats[0].normalCount))
                            StatItemView(caption: "Hard finished:", value: String(colorQuizStats[0].hardCount))
                        }
                        
                        Group {
                            StatCaptionView(caption: "name-quiz")
                            StatItemView(caption: "Finished games:", value: String(nameQuizStats[0].finishedGames))
                            StatItemView(caption: "Guessed names:", value: String(nameQuizStats[0].namesGuessed))
                            StatItemView(caption: "Color Strikes:", value: String(nameQuizStats[0].strikesCount))
                            StatItemView(caption: "Best Strike:", value: String(nameQuizStats[0].bestStrike))
                            StatItemView(caption: "Easy finished:", value: String(nameQuizStats[0].easyCount))
                            StatItemView(caption: "Normal finished:", value: String(nameQuizStats[0].normalCount))
                            StatItemView(caption: "Hard finished:", value: String(nameQuizStats[0].hardCount))
                        }
                    }
                    .frame(width: geometry.size.width * 0.85, alignment: .center)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height - 60, alignment: .top)
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
//        ForEach(["iPhone 8", "iPhone SE (1st generation)", "iPhone 12"], id: \.self) { device in
//            ZStack {
//                BackgroundView()
//                StatsView()
//            }
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//            .previewDevice(PreviewDevice(stringLiteral: device))
//            .previewDisplayName(device)
//        }
        
        Group {
            StatsView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            StatsView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environment(\.locale, Locale(identifier: "en"))
        }
    }
}
