//
//  ColdVsWarmView.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 15.11.2021.
//

import SwiftUI

struct ColdVsWarmView: View {
    
    @EnvironmentObject var settingsState: SettingsState
    
    @State var cardsState: [CardState] = Array(repeating: CardState(), count: 10)
    
    var body: some View {
        VStack {
            
            Text("Cold vs Warm")
            
            ZStack {
                
            }
        }
    }
}

struct ColdVsWarmView_Previews: PreviewProvider {
    static var previews: some View {
        ColdVsWarmView()
    }
}
