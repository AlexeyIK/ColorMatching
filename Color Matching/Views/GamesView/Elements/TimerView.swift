//
//  TimerView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 27.07.2021.
//

import SwiftUI

struct TimerView: View {

    let timerString: String
    
    var body: some View {
        VStack {
//            Text("00:00:000")
            Text(timerString)
                .font( .system(.largeTitle, design: .monospaced))
                .fontWeight(.ultraLight)
                .multilineTextAlignment(.center)
                .frame(width: 300, alignment: .center)
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timerString: "00:01:000")
            .environmentObject(NameQuizState())
    }
}
