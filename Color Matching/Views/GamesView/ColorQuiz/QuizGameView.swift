//
//  QuizGameView.swift
//  Color Matching
//
//  Created by Alexey on 24.07.2021.
//

import SwiftUI

struct QuizGameView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject var gameState: LearnAndQuizState
    @EnvironmentObject var resultStore: QuizResultsStore
    @StateObject var quizState: QuizState = QuizState()
    
    @State var lastAnswerIsCorrect: Bool? = nil
    
    var highlightCorrectAnswer: Bool = false
    var showColorNames: Bool = false
    let scoreFlowSpeed: CGFloat = 55
    
    var body: some View {
        VStack {
            let contentZone = UIScreen.main.bounds
            
            if quizState.results == nil {
                if contentZone.height > 550 {
                    Text("Guess the color")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.light)
//                                .padding(.bottom, 10)
                }
            }
            
            if quizState.quizActive {
                TimerView()
                    .foregroundColor(Color.white)
                    .environmentObject(quizState)
                
                Spacer()
                
                ZStack(alignment: .leading) {
                    ForEach(quizState.quizAnswersAndScore) { quizAnswer in
                        ScorePointView(score: quizAnswer.scoreEarned, isCorrect: quizAnswer.isCorrect)
                            .offset(x: quizAnswer.startOffset * 10.0, y: -CGFloat(quizAnswer.lifetime) * scoreFlowSpeed)
                            .opacity(1 - quizAnswer.lifetime)
                            .scaleEffect(1 + CGFloat(quizAnswer.lifetime) / 10)
                            .animation(.easeOut)
                    }
                }
//                        .offset(x: contentZone.size.width * 0.4, y: 12)
                .offset(y: 6)
                .frame(width: contentZone.width * 0.5, height: contentZone.height * 0.05, alignment: .bottom)
            }
            
            if quizState.quizActive {
                ZStack {
                    ForEach(Array(quizState.quizItemsList.enumerated()), id: \.element) { (index, card) in
                        
                        TransparentCardView(colorModel: card.correct,
                                             drawBorder: true,
                                             drawShadow: index == 0,
                                             showName: showColorNames,
                                             showColor: index == 0 && quizState.isAppActive)
                            .offset(y: CGFloat(index) * -4).zIndex(-Double(index))
                            .scaleEffect(1.0 - CGFloat(index) / 80)
//                                    .zIndex(-Double(index))
                            .transition(quizState.isAppActive ? .swipeToLeft : .opacity)
                            .animation(.easeInOut)
                    }
                }
                .transition(.opacity)
                .frame(width: contentZone.width * 0.68, height: contentZone.height * 0.5, alignment: .center)
            }
            
            VStack {
                if quizState.quizItemsList.count > 0 && !quizState.timeRunOut
                {
                    VStack(spacing: 8) {
                        if let quizItem = quizState.getQuizItem() {
                            ForEach(quizItem.answers) { answer in
                                let colorName = gameState.russianNames ? answer.name : answer.englishName

                                Button(colorName) {
                                    withAnimation {
                                        quizState.quizItemsList.removeFirst()
                                        lastAnswerIsCorrect = quizState.checkAnswer(for: quizItem, answer: answer.id, hardness: gameState.hardness)
                                    }
                                }
                                .transition(.identity)
                                .buttonStyle(QuizButton())
                                .animation(.none)
                                .brightness(highlightCorrectAnswer && answer.id == quizItem.correct.id ? 0.05 : 0)
                            }
                        }
                    }
                    .frame(height: 120)
                    .padding(.vertical, 10)
                    .transition(.identity)
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
            }
            .animation(.easeIn(duration: 0.25))
            
            if (quizState.quizActive) {
                Spacer()
            }
        }
        .padding()
        .blur(radius: quizState.isAppActive ? .nan : 10)
        .onAppear(perform: {
            quizState.startQuiz(cards: gameState.cardsList, hardness: gameState.hardness, russianNames: gameState.russianNames)
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

struct QuizGameView_Previews: PreviewProvider {
    static var previews: some View {
//        ForEach(["iPhone Xs"], id: \.self) { device in
        ForEach(["iPhone SE (1st generation)", "iPhone 8", "iPhone 12 mini"], id: \.self) { device in
            ZStack {
                BackgroundView()
                QuizGameView()
                    .environmentObject(LearnAndQuizState())
                    .environmentObject(QuizResultsStore())
            }
            .previewDevice(PreviewDevice(stringLiteral: device))
            .previewDisplayName(device)
        }
    }
}
