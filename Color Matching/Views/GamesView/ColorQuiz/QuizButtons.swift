//
//  QuizButtons.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 04.08.2021.
//

import SwiftUI

struct QuizButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .foregroundColor(_globalAnswersColor)
            .background(RoundedRectangle(cornerRadius: 36)
                            .stroke(configuration.isPressed ? _globalAnswersColorHighlighted : _globalAnswersColor, lineWidth: 3)
                            .overlay(configuration.isPressed ? RoundedRectangle(cornerRadius: 36).fill(_globalAnswersColorHighlighted) : nil)
            )
            .clipShape(RoundedRectangle(cornerRadius: 36))
    }
}

struct QuizButtonCorrect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12))
            .foregroundColor(_globalAnswersColor)
            .background(configuration.isPressed ? Color.init(red: 0.2, green: 1, blue: 0.2) : Color.init(hue: 0, saturation: 0, brightness: 0.33, opacity: 1))
            .clipShape(RoundedRectangle(cornerRadius: 36))
    }
}

struct QuizButtons: View {
    var body: some View {
        Button("Some button") { }
        .buttonStyle(QuizButton())
    }
}

struct QuizButtons_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            QuizButtons()
        }
    }
}
