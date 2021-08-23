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
            .foregroundColor(_globalAnswersColor)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(RoundedRectangle(cornerRadius: 36)
                            .stroke(configuration.isPressed ? _globalAnswersColorHighlighted : _globalAnswersColor, lineWidth: 1)
                            .overlay(configuration.isPressed ? RoundedRectangle(cornerRadius: 36).fill(_globalAnswersColorHighlighted) : nil)
            )
            .clipShape(RoundedRectangle(cornerRadius: 36))
    }
}

struct QuizButtonIncorrect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .foregroundColor(Color.init(hue: 0, saturation: 1, brightness: 0.63))
            .background(RoundedRectangle(cornerRadius: 36)
                            .stroke(Color.init(hue: 0, saturation: 1, brightness: 0.63), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 36))
    }
}

struct QuizButtonCorrect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(RoundedRectangle(cornerRadius: 36)
                            .stroke(configuration.isPressed ? _globalAnswersColorHighlighted : .white, lineWidth: 1))
//            .clipShape(RoundedRectangle(cornerRadius: 36))
            .shadow(color: Color.white.opacity(1), radius: 8, x: 0, y: 0)
    }
}

struct QuizButtons: View {
    var body: some View {
        Button("Some button") { }
        .buttonStyle(QuizButtonCorrect())
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
