//
//  GuessColorView.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 05.08.2021.
//

import SwiftUI

struct GuessColorView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject var gameState: LearnAndQuizState
    @EnvironmentObject var resultStore: QuizResultsStore
    @StateObject var quizState: QuizState = QuizState()
    
    var highlightCorrectAnswer: Bool = false
    var showColorNames: Bool = false
    let scoreFlowSpeed: CGFloat = 55
    let debugMode: Bool
    
    @State var lastAnswerIsCorrect: Bool? = nil
    @State var rotatePercentage: Double = 0
    @State var newRotation: Double = 180
    @State var swapCards: Bool = false
    
    private let debugAnswers = QuizItem(answers: [colorsData[170], colorsData[180], colorsData[190]], correct: colorsData[190])
    private let debugScores = [QuizAnswer(isCorrect: true, scoreEarned: 12)]
    
    var body: some View {
        ZStack {
            BackgroundView2()
            
            GeometryReader { contentZone in
                // декоративный круг
                Circle()
                    .fill(Color.init(hue: 0, saturation: 0, brightness: 0.12))
                    .frame(width: 160, height: 160, alignment: .center)
                    .offset(x: contentZone.size.width - 100, y: contentZone.size.height - 100)
                
                let item = debugMode ? debugAnswers : quizState.getQuizItem()
            
                VStack(alignment: .center) {
                    if quizState.results == nil {
                        if contentZone.size.height > 550 {
                            Text("Pick right color")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.light)
                                .padding()
                        }
                        
                        if quizState.quizActive || debugMode {
                            TimerView()
                                .foregroundColor(Color.white)
                                .environmentObject(quizState)
                            
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
                                if !quizState.timeRunOut {
                                    Text(gameState.russianNames ? quizItem.correct.name : quizItem.correct.englishName)
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding()
                                        .transition(.slide)
                                        .animation(.none)
                                }
                                else if quizState.timeRunOut && quizState.results == nil {
                                    Text("Time is over!")
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .padding()
                                        .multilineTextAlignment(.center)
                                        .padding(.vertical, 10)
                                        .frame(height: 140)
                                        .transition(.asymmetric(insertion: .scale, removal: .identity))
                                }
                            }.animation(.easeIn(duration: 0.25))
                                
                            Spacer()
                            
                            ZStack(alignment: .center) {
                                let angleStep = Double(90 / quizItem.answers.count)
                                let appActive = lastAnswerIsCorrect == nil && quizState.isAppActive
                                
                                ForEach(quizItem.answers.indices) { index in
                                    PetalView(colorModel: quizItem.answers[index],
                                              name: gameState.russianNames ? quizItem.answers[index].name : quizItem.answers[index].englishName,
                                              showNames: false,
                                              showColor: appActive || quizState.isAppActive && quizItem.answers[index] == quizItem.correct,
                                              hightlight: lastAnswerIsCorrect ?? false && quizItem.answers[index] == quizItem.correct,
                                              blink: lastAnswerIsCorrect == false && quizItem.answers[index] == quizItem.correct)
                                        .frame(width: 340 / CGFloat(quizItem.answers.count), height: 300, alignment: .center)
                                        .transition(.identity)
                                        .modifier(
                                            RollingModifier(toAngle: -75 + angleStep * Double(index) + newRotation, percentage: rotatePercentage, anchor: .bottom) {
                                                
                                                self.rotatePercentage = 0
                                                
                                                if swapCards {
                                                    withAnimation(Animation.easeOut(duration: 0.5).delay(0.1 * Double(index))) {
                                                        self.newRotation -= 180
                                                        self.swapCards = false
                                                        self.lastAnswerIsCorrect = nil
                                                        quizState.quizItemsList.removeFirst()
                                                        quizState.nextQuizItem()
                                                    }
                                                }
                                            }
                                        )
//                                        .animation(Animation.easeOut(duration: 0.6).delay(0.1 * Double(index)), value: rotatePercentage)
                                        .onTapGesture {
                                            lastAnswerIsCorrect = quizState.checkAnswer(for: quizItem, answer: quizItem.answers[index].id, hardness: gameState.hardness)
                                                
                                            withAnimation(Animation.easeInOut(duration: 0.5).delay(0.3 + 0.1 * Double(index))) {
                                                self.newRotation -= 180
                                                rotatePercentage = 1
                                                self.swapCards = true
                                            }
                                        }
                                }
                            }
                            .transition(.opacity)
                            .frame(width: contentZone.size.width * 0.68, height: contentZone.size.height * 0.5, alignment: .bottom)
                            .offset(x: contentZone.size.width * 0.5 - 25, y: -25)
                        }
                    }
                }
                .frame(width: contentZone.size.width, height: contentZone.size.height, alignment: .center)
            }
        }
        .onAppear() {
            quizState.startQuiz(cards: gameState.cardsList, hardness: gameState.hardness, russianNames: gameState.russianNames)
            
            withAnimation(.easeOut(duration: 0.5)) {
                self.newRotation = 0
                rotatePercentage = 1
            }
        }
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
        ZStack {
            BackgroundView()
            GuessColorView(debugMode: true)
                .environmentObject(LearnAndQuizState())
                .environmentObject(QuizResultsStore())
        }
    }
}
