//
//  TimerView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 27.07.2021.
//

import SwiftUI

struct TimerView: View {
    
    @EnvironmentObject var gameState: LearnAndQuizState
//    @State var currentDateTime: Date = Date()
    @State var time: String = "00:00:000"
    let refDateTime: Date
//    var timer: Timer {
//        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {_ in
//            if timeBetweenDates(from: currentDateTime, to: refDateTime) > 0 {
//                self.currentDateTime = Date()
//            } else {
//                withAnimation {
//                    self.timer.invalidate()
//                    gameState.timeRunOut = true
//                }
//            }
//        }
//    }
    let timer = QuizGameManager.shared.startTimer().autoconnect()
    
    var body: some View {
//        let time = gameState.timeRunOut ? "00:00:000" : countDownString(from: refDateTime, until: currentDateTime)
        
        VStack {
            Text(time)
                .font( .system(.largeTitle, design: .monospaced))
                .fontWeight(.ultraLight)
                .multilineTextAlignment(.center)
                .onAppear(perform: {
                    if !gameState.timeRunOut {
                        let _ = self.timer
                    }
                })
                .frame(width: 300, height: 70, alignment: .center)
                
//                Text(String(timeBetweenDates(from: currentDateTime, to: refDateTime)))
//                    .font(.title)
        }
        .onReceive(timer) { tm in
//            self.currentDateTime = Date()
//            time = countDownString(from: refDateTime, until: currentDateTime)
            let timerState = QuizGameManager.shared.getRemainingTime()
            if timerState.active {
                self.time = timerState.time
            } else {
                self.time = timerState.time
                gameState.timeRunOut = true
            }
        }
    }
}

func countDownString(from date: Date, until nowDate: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.minute, .second, .nanosecond], from: nowDate, to: date)
        return String(format: "%02d:%02d:%03d",
                      components.minute ?? 00,
                      components.second ?? 00,
                      (components.nanosecond ?? 000) / 1000000)
}

func timeBetweenDates(from startDate: Date, to endDate: Date) -> TimeInterval {
    return endDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(refDateTime: Date(timeIntervalSinceNow: 10))
            .environmentObject(LearnAndQuizState(definedHardness: .easy))
    }
}
