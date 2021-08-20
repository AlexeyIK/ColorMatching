//
//  ColorQuizStartView.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 07.08.2021.
//

import SwiftUI

struct ColorQuizStartView: View {
    
    @EnvironmentObject var gameState: LearnAndQuizState
    
    @State var card1Offset: CGFloat = -UIScreen.main.bounds.width * 0.6
    @State var card2Offset: CGFloat = UIScreen.main.bounds.width * 0.6
    @State var opacity1: Double = 0
    @State var opacity2: Double = 0
    @State var angle: Double = 100
    @State var perc: Double = 0
    @State var blink: Bool = false
    @State var petalDelay: Double = 2
    
    @State var answers: [ColorModel] = []
    @State var colorRef: ColorModel = colorsData[0]
    @State var timer: Timer? = nil
    
    let rememberColorPreview: ColorModel = colorsData[251] // FF8E0D, заменить на randomElement(), когда база пополнится
    let rememberColorPreviewRus: ColorModel = colorsData[215] // E8793E
    let guessColorPreview: ColorModel = colorsData[251] // заменить на randomElement(), когда база пополнится
    let guessColorPreviewRus: ColorModel = colorsData[215]
    let aspectRatio: CGFloat = 0.75
    let answersColor: Color = Color.init(hue: 0, saturation: 0, brightness: 0.43)
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                    
                    if Locale.current.languageCode == "ru" {
                        Button(gameState.russianNames ? "Рус" : "Eng") {
                            gameState.russianNames.toggle()
                        }
                        .buttonStyle(GoButton2())
                        .font(.system(size: 14))
                        .transition(.identity)
                        .animation(.none)
                        .padding()
                    }
                }
            }
            
            GeometryReader { contentZone in
                VStack {
                    if contentZone.size.height >= 570 {
                        Text("how-to-play")
                            .foregroundColor(.white)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            .padding()
                            .transition(.opacity)
                    }
                    else {
                        Spacer()
                    }
                    
                    VStack {
                        ZStack {
                            TransparentCardView(colorModel: gameState.russianNames ? rememberColorPreviewRus : rememberColorPreview, drawBorder: false, drawShadow: true, showName: false)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                                .frame(width: contentZone.size.width, height: contentZone.size.height * 0.22, alignment: .center)
                                .transition(.identity)
                                .offset(x: card1Offset)
                                .opacity(opacity1)
                            
                            Text("color-quiz-tutor-first")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.medium)
                                .opacity(opacity1)
                                .multilineTextAlignment(.trailing)
                                .shadow(color: .black, radius: 3)
                                .frame(width: 150, alignment: .center)
                                .offset(x: card1Offset - contentZone.size.width * 0.25)
                                .animation(Animation.easeOut(duration: 0.3).delay(0.65), value: card1Offset)
                        }
                        
                        let previewColor = gameState.russianNames ? rememberColorPreviewRus : rememberColorPreview
                        
                        FakeButtonsView(text: gameState.russianNames ? previewColor.name : previewColor.englishName,
                                        foregroundColor: ColorConvert(rgb: previewColor.colorRGB),
                                        outlineColor: ColorConvert(rgb: previewColor.colorRGB))
                            .scaleEffect(0.9)
                            .offset(x: -card1Offset)
                            .transition(.scale)
                            .opacity(opacity1)
                    }
                    
                    Spacer()
                    
                    // Описание Color QUIZ
                    ZStack {
                        Circle()
                            .fill(Color.init(hue: 0, saturation: 0, brightness: 0.12))
                            .frame(width: 50, height: 50, alignment: .center)
                            .offset(y: contentZone.size.height * 0.1)
                            .opacity(opacity2)
//                            .animation
                        
                        ForEach(answers.indices, id: \.self) { i in
                            PetalView(colorModel: answers[i],
                                      showColor: !blink || blink && answers[i].id == colorRef.id,
                                      blink: blink && answers[i].id == colorRef.id,
                                      blinkFreq: 0.25)
                                .frame(width: contentZone.size.height * 0.07, height: contentZone.size.height * 0.22, alignment: .center)
                                .opacity(perc)
                                .modifier(RollingModifier(toAngle: -37.5 + angle + Double(i * 25), percentage: perc, anchor: .bottom, onFinish: {
                                    if timer == nil && !blink {
                                        self.blink = true
                                        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                                            self.blink = false
//                                            print("animation finished")
                                        }
                                    }
                                }))
                                .animation(Animation.easeOut(duration: 0.4 - Double(i) * 0.05).delay(petalDelay + Double(i) * 0.05), value: perc)
                        }
                        
                        Text("color-quiz-tutor-second")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.medium)
                            .opacity(opacity2)
                            .multilineTextAlignment(.center)
                            .shadow(color: .black, radius: 3)
                            .frame(width: 140, alignment: .center)
                            .transition(.identity)
                            .offset(x: card2Offset, y: contentZone.size.height * 0.05)
                            .animation(Animation.easeOut(duration: 0.3).delay(1.4), value: card2Offset)
                    }
                    .onAppear {
                        withAnimation() {
                            angle = 0
                            perc = 1
                        }
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
                                Text(LocalizedStringKey(String(describing: gameState.hardness)))
                                Image(systemName: "chevron.right")
                            }
                        })
                        .buttonStyle(GoButton2())
                        .font(.system(size: 18))
                        .transition(.identity)
                        .animation(.none)
                    }
                    .animation(.none)
                    .frame(width: contentZone.size.width, alignment: .center)
                        
                    Button("go-button.main") {
                        gameState.startGameSession()
                    }
                    .buttonStyle(GoButton2())
                    .font(.system(size: 36))
                    .frame(width: contentZone.size.width, alignment: .center)
                    .transition(.identity)
                    .padding(.bottom, 50)
                    
//                    Spacer()
                }
                .onAppear() {
                    colorRef = gameState.russianNames ? guessColorPreviewRus : guessColorPreview
                    answers = SimilarColorPicker.shared.getSimilarColors(colorRef: colorRef, for: gameState.hardness, variations: 3, withRef: true, noClamp: true, isRussianOnly: gameState.russianNames, useTrueColors: true).shuffled()
                    
                    withAnimation(Animation.easeOut(duration: 0.3).delay(0.3)) {
                        card1Offset = 0
                        opacity1 = 1
                    }
                    withAnimation(Animation.easeOut(duration: 0.3).delay(1.6)) {
                        card2Offset = 0
                        opacity2 = 1
                    }
                }
                .onChange(of: gameState.hardness, perform: { _ in
                    answers = SimilarColorPicker.shared.getSimilarColors(colorRef: colorRef, for: gameState.hardness, variations: 3, withRef: true, noClamp: true, isRussianOnly: gameState.russianNames, useTrueColors: true).shuffled()
                })
                .onChange(of: gameState.russianNames, perform: { _ in
                    colorRef = gameState.russianNames ? guessColorPreviewRus : guessColorPreview
                    answers = SimilarColorPicker.shared.getSimilarColors(colorRef: colorRef, for: gameState.hardness, variations: 3, withRef: true, noClamp: true, isRussianOnly: gameState.russianNames, useTrueColors: true).shuffled()
                    
                    timer?.invalidate()
                    blink = false
                })
            }
        }
    }
}

struct ColorQuizStartView_Previews: PreviewProvider {
    static var previews: some View {
//        ForEach(["iPhone SE (1st generation)", "iPhone 8", "iPhone 12 mini"], id: \.self) { device in
        Group {
            ColorQuizStartView()
                .environmentObject(LearnAndQuizState(quizType: .nameQuiz))
            ColorQuizStartView()
                .environmentObject(LearnAndQuizState(quizType: .nameQuiz))
                .environment(\.locale, Locale(identifier: "ru"))
        }
//                .previewDevice(PreviewDevice(stringLiteral: device))
//                .previewDisplayName(device)
//        }
    }
}
