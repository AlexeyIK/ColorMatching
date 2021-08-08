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
    @State var petalDelay: Double = 1.8
    
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
                            
                            Text("Remember the color and its name")
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
                                        foregroundColor: ConvertColor(rgb: previewColor.colorRGB),
                                        outlineColor: ConvertColor(rgb: previewColor.colorRGB))
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
                            PetalView(colorModel: answers[i], blink: blink && answers[i].id == colorRef.id, blinkFreq: 0.25)
                                .frame(width: contentZone.size.height * 0.075, height: contentZone.size.height * 0.25, alignment: .center)
                                .opacity(perc)
                                .modifier(RollingModifier(toAngle: -37.5 + angle + Double(i * 25), percentage: perc, anchor: .bottom, onFinish: {
                                    blink = true
                                    
                                    timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                                        self.blink = false
                                    }
                                }))
                                .animation(Animation.easeOut(duration: 0.4 - Double(i) * 0.05).delay(petalDelay + Double(i) * 0.05), value: perc)
                        }
                        
                        Text("Choose the right color")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.medium)
                            .opacity(opacity2)
                            .multilineTextAlignment(.center)
                            .shadow(color: .black, radius: 3)
                            .frame(width: 140, alignment: .center)
                            .transition(.identity)
                            .offset(x: card2Offset, y: contentZone.size.height * 0.05)
                            .animation(Animation.easeOut(duration: 0.3).delay(1.55), value: card2Offset)
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
                    colorRef = gameState.russianNames ? guessColorPreviewRus : guessColorPreview
                    answers = SimilarColorPicker.shared.getSimilarColors(colorRef: colorRef, for: gameState.hardness, variations: 3, withRef: true, noClamp: true, isRussianOnly: gameState.russianNames).shuffled()
                    
                    withAnimation(Animation.easeOut(duration: 0.3).delay(0.3)) {
                        card1Offset = 0
                        opacity1 = 1
                    }
                    withAnimation(Animation.easeOut(duration: 0.3).delay(1.4)) {
                        card2Offset = 0
                        opacity2 = 1
                    }
                }
                .onChange(of: gameState.hardness, perform: { _ in
                    answers = SimilarColorPicker.shared.getSimilarColors(colorRef: colorRef, for: gameState.hardness, variations: 3, withRef: true, noClamp: true, isRussianOnly: gameState.russianNames).shuffled()
                })
                .onChange(of: gameState.russianNames, perform: { _ in
                    colorRef = gameState.russianNames ? guessColorPreviewRus : guessColorPreview
                    answers = SimilarColorPicker.shared.getSimilarColors(colorRef: colorRef, for: gameState.hardness, variations: 3, withRef: true, noClamp: true, isRussianOnly: gameState.russianNames).shuffled()
                    
                    opacity2 = 0
                    perc = 0
                    angle = 100
                    petalDelay = 0.1
                    blink = false
                    
                    if timer != nil {
                        timer!.invalidate()
                        timer = nil
                    }
                    
                    withAnimation() {
                        opacity2 = 1
                        perc = 1
                        angle = 0
                    }
                })
            }
        }
    }
}

struct ColorQuizStartView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (1st generation)", "iPhone 8", "iPhone 12 mini"], id: \.self) { device in
            ColorQuizStartView()
                .previewDevice(PreviewDevice(stringLiteral: device))
                .previewDisplayName(device)
                .environmentObject(LearnAndQuizState(quizType: .nameQuiz))
        }
    }
}
