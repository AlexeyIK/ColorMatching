//
//  SettingsView.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 25.08.2021.
//

import SwiftUI

class SettingsState: ObservableObject {
    
    @Published var settingsChanged: Bool = UserDefaults.standard.bool(forKey: "SettingsActivated") {
        didSet {
            UserDefaults.standard.set(settingsChanged, forKey: "SettingsActivated")
        }
    }
    
    @Published var leftHandMode: Bool = UserDefaults.standard.bool(forKey: "leftHandOn") {
        didSet {
            settingsChanged = true
            UserDefaults.standard.set(leftHandMode, forKey: "leftHandOn")
        }
    }
    @Published var tactileFeedback: Bool = UserDefaults.standard.bool(forKey: "tactileFeedback") {
        didSet {
            settingsChanged = true
            UserDefaults.standard.set(tactileFeedback, forKey: "tactileFeedback")
        }
    }
    @Published var sounds: Bool = UserDefaults.standard.bool(forKey: "sounds") {
        didSet {
            settingsChanged = true
            UserDefaults.standard.set(sounds, forKey: "sounds")
        }
    }
    
    init() {
        if !settingsChanged {
            // defaults
            leftHandMode = false
            tactileFeedback = true
            sounds = true
        }
    }
}

struct SettingsView: View {
    
    @EnvironmentObject var settingsState: SettingsState
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                Text("settings-title")
                    .font(.title)
                    .fontWeight(.regular)
                    .foregroundColor(_globalMenuTitleColor)
                    .padding(.top, 28)
                
                Form {
                    Toggle("Left Hand", isOn: $settingsState.leftHandMode)
                        .listRowBackground(Color.black)
                    Toggle("Tactile feedback", isOn: $settingsState.tactileFeedback)
                        .listRowBackground(Color.black)
                    Toggle("Sounds", isOn: $settingsState.sounds)
                        .listRowBackground(Color.black)
                }
                .foregroundColor(.white)
            }
        }
        .onAppear() {
            UITableView.appearance().backgroundColor = .clear
        }
        .onDisappear() {
            UITableView.appearance().backgroundColor = .systemGroupedBackground
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsView()
                .environmentObject(SettingsState())
            SettingsView()
                .environmentObject(SettingsState())
                .environment(\.locale, Locale(identifier: "ru"))
        }
    }
}
