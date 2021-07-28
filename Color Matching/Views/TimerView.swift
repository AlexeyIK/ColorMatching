//
//  TimerView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 27.07.2021.
//

import SwiftUI

struct TimerView: View {
    
    @EnvironmentObject var quizState: QuizState
    
    var body: some View {
        VStack {
//            Text("00:00:000")
            Text(quizState.timerString)
                .font( .system(.largeTitle, design: .monospaced))
                .fontWeight(.ultraLight)
                .multilineTextAlignment(.center)
                .frame(width: 300, height: 70, alignment: .center)
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .environmentObject(QuizState())
    }
}
