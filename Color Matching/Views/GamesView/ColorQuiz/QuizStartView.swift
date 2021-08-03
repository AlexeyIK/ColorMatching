//
//  QuizStartView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 03.08.2021.
//

import SwiftUI

struct QuizStartView: View {
    
    @EnvironmentObject var gameState: LearnAndQuizState
    
    @State var card1Offset: CGFloat = -UIScreen.main.bounds.width * 0.6
    @State var card2Offset: CGFloat = UIScreen.main.bounds.width * 0.6
    @State var opacity1: Double = 0
    @State var opacity2: Double = 0
    
    let rememberColorPreview: ColorModel = colorsData[1445] // заменить на randomElement(), когда база пополнится
    let guessColorPreview: ColorModel = colorsData[420] // заменить на randomElement(), когда база пополнится
    let answers = SimilarColorPicker.shared.getSimilarColors(colorRef: colorsData[420], for: .easy, withRef: true, noClamp: true)
    let aspectRatio: CGFloat = 0.7
    let answersColor: Color = Color.init(hue: 0, saturation: 0, brightness: 0.43)
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            GeometryReader { contentZone in
                VStack {
                    Text("how to play?")
                        .foregroundColor(.white)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                        .transition(.opacity)
//                        .transition(.slide)
//                        .animation(Animation.default.delay(0.4))
                    
                    VStack {
                        ZStack {
                            TransparentCardView(colorModel: rememberColorPreview, drawBorder: false, drawShadow: true, showName: false)
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
                        
                        FakeButtonsView(text: rememberColorPreview.englishName,
                                        foregroundColor: ConvertColor(rgb: rememberColorPreview.colorRGB),
                                        outlineColor: ConvertColor(rgb: rememberColorPreview.colorRGB))
                            .scaleEffect(0.8)
                            .offset(x: -card1Offset)
                            .transition(.scale)
                            .opacity(opacity1)
//                            .animation(Animation.easeOut(duration: 0.3).delay(0.6), value: card1Offset)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        HStack {
                            VStack {
                                ForEach(answers) { answer in
                                    FakeButtonsView(text: answer.englishName != "" ? answer.englishName : answer.name,
                                                    foregroundColor: answersColor,
                                                    outlineColor: answersColor)
                                }
                            }
                            .scaleEffect(0.7)
                            .offset(x: -card2Offset)
                            .opacity(opacity1)
                            
                            TransparentCardView(colorModel: guessColorPreview, drawBorder: false, drawShadow: true, showName: false)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                                .frame(height: contentZone.size.height * 0.22, alignment: .center)
                                .transition(.identity)
                                .offset(x: card2Offset)
                                .opacity(opacity2)
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
                            .offset(x: card2Offset + contentZone.size.width * 0.25)
                            .animation(Animation.easeOut(duration: 0.3).delay(2), value: card2Offset)
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
                        gameState.activeGameMode = .learn
                    }
                    .buttonStyle(GoButton2())
                    .font(.system(size: 40))
                    .frame(width: contentZone.size.width, alignment: .center)
                    .transition(.identity)
                    
                    Spacer()
                }
                .onAppear() {
                    withAnimation(Animation.easeOut(duration: 0.3).delay(0.3)) {
                        card1Offset = 0
                        opacity1 = 1
                    }
                    withAnimation(Animation.easeOut(duration: 0.3).delay(1.75)) {
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
            QuizStartView()
                .previewDevice(PreviewDevice(stringLiteral: device))
                .previewDisplayName(device)
                .environmentObject(LearnAndQuizState())
        }
    }
}
