//
//  FakeButtonsView.swift
//  Color Matching
//
//  Created by Алексей Кузнецов on 03.08.2021.
//

import SwiftUI

struct FakeButtonsView: View {
    
    let text: String
    var foregroundColor: Color = .gray
    var outlineColor: Color = .gray
    var fill: Bool = false
    var multiline: Bool = false
    
    var body: some View {
        Text(text)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .foregroundColor(foregroundColor)
            .background(RoundedRectangle(cornerRadius: 36)
                            .stroke(outlineColor, lineWidth: 2)
                            .overlay(fill ? outlineColor.opacity(0.7) : nil))
            .clipShape(RoundedRectangle(cornerRadius: 36))
            .multilineTextAlignment(.center)
            .lineLimit(multiline ? 3 : 1)
            .frame(minWidth: 50, idealWidth: 150, maxWidth: 200, alignment: .center)
    }
}

struct FakeButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            FakeButtonsView(text: "Fake button", foregroundColor: .white, outlineColor: .gray, fill: true)
        }
    }
}
