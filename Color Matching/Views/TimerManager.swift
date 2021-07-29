//
//  TimerManager.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 28.07.2021.
//

import Foundation

class TimerManager {
    
    private init() { }
    
    static let shared = TimerManager()
    
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
}
