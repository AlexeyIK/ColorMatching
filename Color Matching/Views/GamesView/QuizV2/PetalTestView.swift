//
//  PetalTestView.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 06.08.2021.
//

import SwiftUI

struct PetalTestView: View {
    
    @State var outerWidth: CGFloat = 45
    @State var innerWidth: CGFloat = 20
    
    let innerRoundness: CGFloat = 0.12
    let outerRoundness: CGFloat = 0.65
    
    @State var angle: Double = -30
    @State var perc: Double = 0
    @State var needToRestore: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(0..<3) { i in
                    PetalView(colorModel: colorsData[300 + i], blink: needToRestore)
                        .frame(width: 100, height: 300, alignment: .center)
                        .modifier(RollingModifier(toAngle: angle + Double(i * 30), percentage: perc, anchor: .bottom, onFinish: {
                            perc = 0
                            
                            if needToRestore {
//                                withAnimation(Animation.easeInOut(duration: 0.7 - 0.1 * Double(3 - i)).delay(0.1 * Double(3 - i))) {
                                    angle += 180
                                    perc = 1
                                    needToRestore = false
//                                }
                            }
                        }))
                        .animation(Animation.easeInOut(duration: 0.7 - 0.1 * Double(3 - i)).delay(0.2 + 0.1 * Double(3 - i)), value: perc)
                }
            }
        
            Button("Animate") {
//                withAnimation(.easeInOut(duration: 0.7)) {
                    angle += 180
                    perc = 1
                    needToRestore = true
//                }
            }
        }
    }
}

struct RollingModifier: AnimatableModifier {
    
    var animatableData: Double {
        get { percentage }
        set {
            percentage = newValue
            checkIsFinish()
        }
    }
    
    var toAngle: Double = 0
    var percentage: Double
    var anchor: UnitPoint = .center
    let onFinish: () -> ()
    
    func checkIsFinish() {
        if (percentage == 1) {
            DispatchQueue.main.async {
                self.onFinish()
            }
        }
    }
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: toAngle), anchor: anchor)
      }
    
}

struct PetalTestView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            PetalTestView()
        }
    }
}
