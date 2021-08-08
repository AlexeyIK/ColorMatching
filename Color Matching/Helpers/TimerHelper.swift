//
//  TimerHelper.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 28.07.2021.
//

import Foundation
import SwiftUI
import Combine

enum TimerState {
    case stopped
    case paused
    case running
    case runout
}

class TimerHelper {
    
    private init() { }
    
    static let shared = TimerHelper()
    
    // constants
    private let definedTimerFrequence: Double = 0.01
    
    // private
    private var countdownTimer: Timer.TimerPublisher? = nil
    private var currentDateTime: Date = Date()
    private var endDateTime: Date = Date()
    private var saveElapsedTime: TimeInterval = 0
    private var cancellable: AnyCancellable? = nil
    
    /// Запускает внутренний таймер, который выступает в роли счетчика времени
    func setTimer(for time: Double, run: Bool = true) -> Publishers.Autoconnect<Timer.TimerPublisher> {
        currentDateTime = Date()
        endDateTime = Date.init(timeIntervalSinceNow: time)
        
        cancellable?.cancel()
        countdownTimer = Timer.publish(every: definedTimerFrequence, on: .main, in: .common)
        cancellable = countdownTimer!.autoconnect().sink(receiveValue: { (date) in
            self.currentDateTime = date
        })
        
        return countdownTimer!.autoconnect()
    }
    
    func compensateTimer(for time: TimeInterval) {
        endDateTime = Date.init(timeIntervalSinceNow: time)
    }
    
    func pauseTimer() {
        saveElapsedTime = self.endDateTime.timeIntervalSinceReferenceDate - self.currentDateTime.timeIntervalSinceReferenceDate
    }
    
    func resumeTimer() {
        endDateTime = Date.init(timeIntervalSinceNow: saveElapsedTime)
        print("Timer resumed")
    }
    
    func cancelTimer() {
        cancellable?.cancel()
        print("Timer canceled")
    }
    
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
    
    func getRemainingTimeFomatted() -> String
    {
        let timeRemainsStr = countDownString(from: endDateTime, until: currentDateTime)
        if endDateTime.timeIntervalSinceReferenceDate - currentDateTime.timeIntervalSinceReferenceDate > 0 {
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

    func timeBetweenDates() -> TimeInterval {
        return endDateTime.timeIntervalSinceReferenceDate - currentDateTime.timeIntervalSinceReferenceDate
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
