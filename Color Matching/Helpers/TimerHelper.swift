//
//  TimerHelper.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 28.07.2021.
//

import Foundation

class TimerHelper {
    
    private init() { }
    
    // constants
    private let definedTimerFrequence: Double = 0.01
    
    // private
    private var isTimerPaused: Bool = false
    
    var countdownTimer: Timer?
    var currentDateTime: Date = Date()
    var endDateTime: Date = Date()
    
    static let shared = TimerHelper()
    
//    func startTimer(for time: Double) -> Timer.TimerPublisher {
//        currentDateTime = Date()
//        endDateTime = Date.init(timeIntervalSinceNow: time)
//        countdownTimer = Timer.publish(every: 0.02, on: .main, in: .common)
//
//        return countdownTimer!
//    }
    
    func getTimeIntervalFomatted(from refDateTime: Date, until endDateTime: Date) -> String
    {
        let timeRemainsStr = countDownString(from: endDateTime, until: refDateTime)
        if endDateTime.timeIntervalSinceReferenceDate - refDateTime.timeIntervalSinceReferenceDate > 0 {
            return timeRemainsStr
        }
        else {
            return "00:00:000"
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

    // ToDo: сделать нормальный единый менеджер таймера
    /*
    func startTimer(for time: Double) -> Timer.TimerPublisher {
        currentDateTime = Date()
        endDateTime = Date.init(timeIntervalSinceNow: time)

        countdownTimer = Timer.scheduledTimer(withTimeInterval: definedTimerFrequence, repeats: true, block: { _ in
            guard !self.isTimerPaused else { return }

            self.currentDateTime = Date()
            self.timerString = TimerHelper.shared.getTimeIntervalFomatted(from: self.currentDateTime, until: self.endDateTime)

            self.quizAnswersAndScore.forEach { quizAnswer in
                quizAnswer.liveTimeInc(seconds: self.definedTimerFrequence)
            }

            if self.endDateTime.timeIntervalSinceReferenceDate - self.currentDateTime.timeIntervalSinceReferenceDate <= 0 {
                self.timeRunOut = true
                self.startGameEndPause()
            }
        })
    }*/
}
