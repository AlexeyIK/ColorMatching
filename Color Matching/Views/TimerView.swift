//
//  TimerView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 27.07.2021.
//

import SwiftUI

struct TimerView: View {
    
    @EnvironmentObject var gameState: LearnAndQuizState
    @State var currentDateTime: Date = Date()
    let refDateTime: Date
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {_ in
            if timeBetweenDates(from: currentDateTime, to: refDateTime) > 0.01 {
                self.currentDateTime = Date()
            } else {
                gameState.timeRunOut = true
            }
        }
    }
    
    var body: some View {
        let time = gameState.timeRunOut ? "00:00:000" : countDownString(from: refDateTime, until: currentDateTime)
        
        Text(time)
            .font(.largeTitle)
            .fontWeight(.thin)
            .multilineTextAlignment(.leading)
            .onAppear(perform: {
                if !gameState.timeRunOut {
                    let _ = self.timer
                }
            })
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
        TimerView(refDateTime: Date(timeIntervalSinceNow: 60))
    }
}
