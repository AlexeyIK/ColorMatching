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
    @FetchRequest(entity: ViewedColor.entity(), sortDescriptors: [], predicate: NSPredicate(format: "isGuessed == true")) var viewedColors: FetchedResults<ViewedColor>
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack() {
                Text("Stats")
                    .font(.largeTitle)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                    .kerning(6)
                    .padding(.bottom, 60)
                
                ScrollView(.vertical, showsIndicators: false) {
                    StatItemView(caption: "Collected Соlor Coins", value: String(playerStats[0].totalScore))
                    StatItemView(caption: "Last game Color Coins", value: String(playerStats[0].lastGameScore))
                    StatItemView(caption: "Total games finished", value: String(playerStats[0].totalFinishedGames))
                    
                    StatCaptionView(caption: "Color QUIZ")
                    StatItemView(caption: "Finished games", value: String(colorQuizStats[0].finishedGames))
                    StatItemView(caption: "Guessed colors", value: String(colorQuizStats[0].colorsGuessed))
                    StatItemView(caption: "Guessed unique colors", value: String(viewedColors.count))
                    StatItemView(caption: "Color Strikes", value: String(colorQuizStats[0].strikesCount))
                    StatItemView(caption: "Best Strike", value: String(colorQuizStats[0].bestStrike))
                }
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.8, alignment: .center)
        }
        .navigationBarItems(
            leading:
                HStack {
                    Image(systemName: "chevron.left")
                        .foregroundColor(_globalNavBarButtonsColor)
                    
                    Button("Back") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(BackButton())
                }
        )
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone 8", "iPhone SE (1st generation)", "iPhone 12"], id: \.self) { device in
            ZStack {
                BackgroundView()
                StatsView()
            }
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewDevice(PreviewDevice(stringLiteral: device))
            .previewDisplayName(device)
        }
    }
}
