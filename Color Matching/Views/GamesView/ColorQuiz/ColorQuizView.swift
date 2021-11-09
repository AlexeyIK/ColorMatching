//
//  ColorQuizView.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 05.08.2021.
//

import SwiftUI

struct ColorQuizView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject var gameState: LearnAndQuizState
    @EnvironmentObject var resultStore: QuizResultsStore
    @EnvironmentObject var settingsState: SettingsState
    @StateObject var quizState: ColorQuizState = ColorQuizState()

    var highlightCorrectAnswer: Bool = false
    var showColorNames: Bool = false
    let scoreFlowSpeed: CGFloat = 55
    let debugMode: Bool
    
    @State var lastAnswerIsCorrect: Bool? = nil
    @State var rotatePercentage: Double = 0
    @State var newRotation: Double = 180
    @State var swapCards: Bool = false
    @State var answerTimer: Timer? = nil
    
    private let debugAnswers = QuizItem(answers: [colorsData[170], colorsData[180], colorsData[190], colorsData[200]], correct: colorsData[190])
    private let debugScores = [QuizAnswer(isCorrect: true, scoreEarned: 12)]
    
    var body: some View {
        ZStack {
            BackgroundView2()
            
            GeometryReader { contentZone in
                // декоративный круг
                Circle()
                    .fill(Color.init(hue: 0, saturation: 0, brightness: 0.12))
                    .frame(width: 160, height: 160, alignment: .center)
                    .offset(x: contentZone.size.width - 80, y: contentZone.size.height - 80)
                
                let item = debugMode ? debugAnswers : quizState.getQuizItem()
            
                VStack(alignment: .center) {
                    if quizState.results == nil {
                        if contentZone.size.height > 550 {
                            Text("pick-the-right-color")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.light)
                                .padding(.top, 20)
                        }
                        
                        if quizState.quizActive || debugMode {
                            TimerView(timerString: quizState.timerString)
                                .foregroundColor(Color.white)
                                .padding(.top, 2)
                            
                            Spacer()
                            
                            if item != nil {
                                ZStack(alignment: .leading) {
                                    ForEach(debugMode ? debugScores : quizState.quizAnswersAndScore) { quizAnswer in
                                        ScorePointView(score: quizAnswer.scoreEarned, isCorrect: quizAnswer.isCorrect)
                                            .offset(x: quizAnswer.startOffset * 10.0, y: -CGFloat(quizAnswer.lifetime) * scoreFlowSpeed)
                                            .opacity(1 - quizAnswer.lifetime)
                                            .scaleEffect(1 + CGFloat(quizAnswer.lifetime) / 10)
                                            .animation(.easeOut)
                                    }
                                }
                                .offset(y: 6)
                                .frame(width: contentZone.size.width * 0.5, height: contentZone.size.height * 0.05, alignment: .bottom)
                            }
                            else {
                                Spacer()
                            }
                        }
                        
                        if let quizItem = item {
                            VStack {
                                if quizState.timerStatus != .runout && !swapCards {
                                    Text(gameState.russianNames ? quizItem.correct.name : quizItem.correct.englishName)
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(width: contentZone.size.width)
                                        .animation(.spring(response: 0.2, dampingFraction: 0.6, blendDuration: 0))
                                        .transition(.asymmetric(insertion: settingsState.leftHandMode ? .move(edge: .leading) : .move(edge: .trailing), removal: .opacity))
                                }
                                else if quizState.timerStatus == .runout && quizState.results == nil {
                                    Text("time-over")
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .padding()
                                        .multilineTextAlignment(.center)
                                        .padding(.vertical, 10)
                                        .frame(height: 140)
                                        .transition(.asymmetric(insertion: .scale, removal: .identity))
                                }
                            }
                            .animation(.easeOut(duration: 0.25))
                                
                            Spacer()
                            
                            ZStack(alignment: .center) {
                                let angleStep = Double(90 / quizItem.answers.count)
                                let appActive = lastAnswerIsCorrect == nil && quizState.isAppActive
                                let flowerZoneDemention = max(260, contentZone.size.width * 0.8)
                                let startAngle = 90 - angleStep / 2
                                
                                ForEach(quizItem.answers.indices) { index in
                                    // Если включен леворукий режим, то крутим все по часовой стрелке
                                    if settingsState.leftHandMode {
                                        PetalView(colorModel: quizItem.answers[index],
                                                  name: gameState.russianNames ? quizItem.answers[index].name : quizItem.answers[index].englishName,
                                                  showNames: false,
                                                  showColor: appActive || quizState.isAppActive && quizItem.answers[index] == quizItem.correct,
                                                  hightlight: lastAnswerIsCorrect ?? false && quizItem.answers[index] == quizItem.correct,
                                                  blink: lastAnswerIsCorrect == false && quizItem.answers[index] == quizItem.correct)
                                            .frame(width: (flowerZoneDemention + 50) / CGFloat(quizItem.answers.count), height: flowerZoneDemention, alignment: .center)
                                            .transition(.identity)
                                            .modifier(
                                                RollingModifier(toAngle: startAngle - angleStep * Double(index) + newRotation, percentage: rotatePercentage, anchor: .bottom) {
                                                    
                                                    self.rotatePercentage = 0
                                                    
                                                    if quizState.isAppActive && quizState.quizActive && quizState.timerStatus == .stopped {
                                                        quizState.runTimer()
                                                    }
                                                    
                                                    if swapCards && quizState.timerStatus != .runout {
                                                        self.newRotation += 120
                                                        self.swapCards = false
                                                        self.lastAnswerIsCorrect = nil
                                                        if (self.answerTimer != nil) {
                                                            self.answerTimer!.invalidate()
                                                        }
                                                        quizState.quizItemsList.removeFirst()
                                                        quizState.nextQuizItem()
                                                        
                                                        withAnimation() {
                                                            self.newRotation += 120
                                                            self.rotatePercentage = 1
                                                        }
                                                    }
                                                }
                                            )
                                            .onTapGesture {
                                                if quizState.timerStatus != .runout && !swapCards {
                                                    lastAnswerIsCorrect = quizState.checkAnswer(for: quizItem, answer: quizItem.answers[index].id, hardness: gameState.hardness)
                                                    self.swapCards = true
                                                    
                                                    if lastAnswerIsCorrect == true {
                                                        SoundPlayer.shared.playSound(type: .answerCorrect)
                                                    } else {
                                                        SoundPlayer.shared.playSound(type: .answerWrong)
                                                    }
                                                    
//                                                    SoundPlayer.shared.playSound(type: .click2)
                                                    
                                                    if settingsState.tactileFeedback {
                                                        let hapticImpact = UINotificationFeedbackGenerator()
                                                        hapticImpact.notificationOccurred(lastAnswerIsCorrect! ? .success : .error)
                                                    }
                                                    
                                                    answerTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) {_ in
                                                        withAnimation() {
                                                            self.newRotation += 120
                                                            self.rotatePercentage = 1
                                                        }
                                                    }
                                                }
                                            }
                                            .animation(Animation.easeInOut(duration: 0.15 + Double(quizItem.answers.count) * 0.1 - 0.1 * Double(index)).delay(0.1 * Double(index)), value: rotatePercentage)
                                    } // Если же нет, то крутим против часовой стрелки
                                    else {
                                        PetalView(colorModel: quizItem.answers[index],
                                                  name: gameState.russianNames ? quizItem.answers[index].name : quizItem.answers[index].englishName,
                                                  showNames: false,
                                                  showColor: appActive || quizState.isAppActive && quizItem.answers[index] == quizItem.correct,
                                                  hightlight: lastAnswerIsCorrect ?? false && quizItem.answers[index] == quizItem.correct,
                                                  blink: lastAnswerIsCorrect == false && quizItem.answers[index] == quizItem.correct)
                                            .frame(width: (flowerZoneDemention + 50) / CGFloat(quizItem.answers.count), height: flowerZoneDemention, alignment: .center)
                                            .transition(.identity)
                                            .modifier(
                                                RollingModifier(toAngle: -startAngle + angleStep * Double(index) + newRotation, percentage: rotatePercentage, anchor: .bottom) {
                                                    
                                                    self.rotatePercentage = 0
                                                    
                                                    if quizState.isAppActive && quizState.quizActive && quizState.timerStatus == .stopped {
                                                        quizState.runTimer()
                                                    }
                                                    
                                                    if swapCards && quizState.timerStatus != .runout {
                                                        self.newRotation -= 120
                                                        self.swapCards = false
                                                        self.lastAnswerIsCorrect = nil
                                                        if (self.answerTimer != nil) {
                                                            self.answerTimer!.invalidate()
                                                        }
                                                        quizState.quizItemsList.removeFirst()
                                                        quizState.nextQuizItem()
                                                        
                                                        withAnimation() {
                                                            self.newRotation -= 120
                                                            self.rotatePercentage = 1
                                                        }
                                                    }
                                                }
                                            )
                                            .onTapGesture {
                                                if quizState.timerStatus != .runout && !swapCards {
                                                    lastAnswerIsCorrect = quizState.checkAnswer(for: quizItem, answer: quizItem.answers[index].id, hardness: gameState.hardness)
                                                    self.swapCards = true
                                                    
                                                    if lastAnswerIsCorrect == true {
                                                        SoundPlayer.shared.playSound(type: .answerCorrect)
                                                    } else {
                                                        SoundPlayer.shared.playSound(type: .answerWrong)
                                                    }
                                                    
                                                    if settingsState.tactileFeedback {
                                                        let hapticImpact = UINotificationFeedbackGenerator()
                                                        hapticImpact.notificationOccurred(lastAnswerIsCorrect! ? .success : .error)
                                                    }
                                                    
                                                    answerTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) {_ in
                                                        withAnimation() {
                                                            self.newRotation -= 120
                                                            self.rotatePercentage = 1
                                                        }
                                                    }
                                                }
                                            }
                                            .animation(Animation.easeInOut(duration: 0.15 + Double(quizItem.answers.count) * 0.1 - 0.1 * Double(index)).delay(0.1 * Double(index)), value: rotatePercentage)
                                    }
                                }
                            }
                            .transition(.opacity)
                            .frame(width: contentZone.size.width * 0.68, height: contentZone.size.height * 0.5, alignment: .bottom)
                            .offset(x: settingsState.leftHandMode ? -contentZone.size.width * 0.5 + 10 : contentZone.size.width * 0.5 - 10, y: -10)
                        }
                    }
                }
                .frame(width: contentZone.size.width, height: contentZone.size.height, alignment: .center)
            }
        }
        .onAppear() {
            quizState.startQuiz(cards: gameState.cardsList, hardness: gameState.hardness, russianNames: gameState.russianNames, runTimer: false)
            
            if settingsState.leftHandMode {
                self.newRotation = -180
            }
            
            withAnimation(.easeOut(duration: 0.4)) {
                self.newRotation = 0
                self.rotatePercentage = 1
            }
        }
        .onChange(of: quizState.timerStatus, perform: { status in
            if status == .runout {
                self.rotatePercentage = 0
                
                withAnimation() {
                    self.newRotation += settingsState.leftHandMode ? 120 : -120
                    self.rotatePercentage = 1
                }
            }
        })
        // мониторим, что квиз сменил активность
        .onChange(of: quizState.quizActive) { _ in
            if let results = quizState.results {
                resultStore.quizResults = results
                resultStore.colorsViewed = quizState.colorsViewed
                
                withAnimation {
                    gameState.activeGameMode = .results
                }
            }
        }
        // мониторим, что приложение свернули и паузим таймер и сменяем статус
        .onChange(of: scenePhase) { phase in
            switch phase {
                case .inactive:
                    quizState.isAppActive = false
                    quizState.pauseTimer()
                case .active:
                    quizState.isAppActive = true
                    quizState.resumeTimer()
                default:
                    return
            }
        }
    }
}

struct GuessColorView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (1st generation)", "iPhone 8", "iPhone 12"], id: \.self) { device in
            ZStack {
                BackgroundView()
                ColorQuizView(debugMode: true)
                    .environmentObject(LearnAndQuizState(quizType: .colorQuiz))
                    .environmentObject(QuizResultsStore())
                    .environmentObject(SettingsState())
            }
            .previewDevice(PreviewDevice(stringLiteral: device))
            .previewDisplayName(device)
        }
    }
}
