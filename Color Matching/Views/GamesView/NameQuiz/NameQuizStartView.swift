//
//  NameQuizStartView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 03.08.2021.
//

import SwiftUI

struct NameQuizStartView: View {
    
    @EnvironmentObject var gameState: LearnAndQuizState
    
    @State var card1Offset: CGFloat = -UIScreen.main.bounds.width * 0.6
    @State var card2Offset: CGFloat = UIScreen.main.bounds.width * 0.6
    @State var opacity1: Double = 0
    @State var opacity2: Double = 0
    
    let rememberColorPreview: ColorModel = colorsData[1445] // заменить на randomElement(), когда база пополнится
    let rememberColorPreviewRus: ColorModel = colorsData[1439]
    let guessColorPreview: ColorModel = colorsData[420] // заменить на randomElement(), когда база пополнится
    let guessColorPreviewRus: ColorModel = colorsData[402]
    let aspectRatio: CGFloat = 0.75
    let answersColor: Color = Color.init(hue: 0, saturation: 0, brightness: 0.43)
    
    var body: some View {
        
        let answers = SimilarColorPicker.shared.getSimilarColors(colorRef: gameState.russianNames ? guessColorPreviewRus : guessColorPreview, for: gameState.hardness, withRef: true, noClamp: true, isRussianOnly: gameState.russianNames).shuffled()
        
        ZStack {
            BackgroundView()
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                    
                    Button(gameState.russianNames ? "Rus" : "Eng") {
                        gameState.russianNames.toggle()
                    }
                    .buttonStyle(GoButton2())
                    .font(.system(size: 14))
                    .transition(.identity)
                    .animation(.none)
                    .padding()
                }
            }
            
            GeometryReader { contentZone in
                VStack {
                    Text("how to play?")
                        .foregroundColor(.white)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                        .transition(.opacity)
                    
                    VStack {
                        ZStack {
                            TransparentCardView(colorModel: gameState.russianNames ? rememberColorPreviewRus : rememberColorPreview, drawBorder: false, drawShadow: true, showName: false)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                                .frame(width: contentZone.size.width, height: contentZone.size.height * 0.22, alignment: .center)
                                .transition(.identity)
                                .offset(x: card1Offset)
                                .opacity(opacity1)
                            
                            Text("Remember the color name")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.medium)
    //                            .padding()
                                .multilineTextAlignment(.trailing)
                                .shadow(color: .black, radius: 3)
                                .frame(width: 110, alignment: .center)
                                .offset(x: card1Offset - contentZone.size.width * 0.25)
//                                .transition(.move(edge: .leading))
                                .animation(Animation.easeOut(duration: 0.3).delay(0.6), value: card1Offset)
                        }
                        
                        let previewColor = gameState.russianNames ? rememberColorPreviewRus : rememberColorPreview
                        
                        FakeButtonsView(text: previewColor.name != "" ? previewColor.name : previewColor.englishName,
                                        foregroundColor: ConvertColor(rgb: previewColor.colorRGB),
                                        outlineColor: ConvertColor(rgb: previewColor.colorRGB))
                            .scaleEffect(0.9)
                            .offset(x: -card1Offset)
                            .transition(.scale)
                            .opacity(opacity1)
//                            .animation(Animation.easeOut(duration: 0.3).delay(0.6), value: card1Offset)
                    }
                    
                    Spacer()
                    
                    // Описание Name QUIZ
                    ZStack {
                        HStack {
                            VStack {
                                ForEach(answers, id: \.self) { answer in
                                    FakeButtonsView(text: gameState.russianNames ? answer.name : answer.englishName,
                                                    foregroundColor: answersColor,
                                                    outlineColor: answersColor)
                                }
                            }
                            .scaleEffect(0.7)
                            .offset(x: -card2Offset)
                            .opacity(opacity1)
                            
                            TransparentCardView(colorModel: gameState.russianNames ? guessColorPreviewRus : guessColorPreview, drawBorder: false, drawShadow: true, showName: false)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                                .frame(height: contentZone.size.height * 0.22, alignment: .center)
                                .transition(.identity)
                                .offset(x: card2Offset)
                                .opacity(opacity2)
                                .layoutPriority(1)
                                .padding(.trailing, 24)
                        }
                        
                        Text("Choose the right name")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.medium)
//                            .padding()
                            .multilineTextAlignment(.leading)
                            .shadow(color: .black, radius: 3)
                            .frame(width: 110, alignment: .center)
                            .transition(.identity)
                            .offset(x: card2Offset + contentZone.size.width * 0.3)
                            .animation(Animation.easeOut(duration: 0.3).delay(1.8), value: card2Offset)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Button(action: {
                            if gameState.hardness == Hardness.easy {
                                gameState.hardness = Hardness.normal
                            }
                            else if gameState.hardness == Hardness.normal {
                                gameState.hardness = Hardness.hard
                            }
                            else if gameState.hardness == Hardness.hard {
                                gameState.hardness = Hardness.easy
                            }
                        }, label: {
                            HStack {
                                Text(String(describing: gameState.hardness).capitalized)
                                Image(systemName: "chevron.right")
                            }
                        })
                        .buttonStyle(GoButton2())
                        .font(.system(size: 20))
                        .transition(.identity)
                        .animation(.none)
                    }
                    .animation(.none)
                    .frame(width: contentZone.size.width, alignment: .center)
                        
                    Button("Go!") {
                        gameState.startGameSession()
                    }
                    .buttonStyle(GoButton2())
                    .font(.system(size: 40))
                    .frame(width: contentZone.size.width, alignment: .center)
                    .transition(.identity)
                    .padding(.bottom, 50)
                    
//                    Spacer()
                }
                .onAppear() {
                    withAnimation(Animation.easeOut(duration: 0.3).delay(0.3)) {
                        card1Offset = 0
                        opacity1 = 1
                    }
                    withAnimation(Animation.easeOut(duration: 0.3).delay(1.5)) {
                        card2Offset = 0
                        opacity2 = 1
                    }
                }
            }
        }
    }
}

struct QuizStartView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (1st generation)", "iPhone 8", "iPhone 12 mini"], id: \.self) { device in
            NameQuizStartView()
                .previewDevice(PreviewDevice(stringLiteral: device))
                .previewDisplayName(device)
                .environmentObject(LearnAndQuizState(quizType: .nameQuiz))
        }
    }
}
