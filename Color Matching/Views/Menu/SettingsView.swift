//
//  SettingsView.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 25.08.2021.
//

import SwiftUI

enum ColorLang: String, CaseIterable {
    case russian
    case english
}

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
            SoundPlayer.shared.soundsOff = !sounds
            UserDefaults.standard.set(sounds, forKey: "sounds")
        }
    }
    
    @Published var colorsLang: ColorLang = ColorLang(rawValue: UserDefaults.standard.string(forKey: "colorsLang") ?? "") ?? .english  {
        didSet {
            settingsChanged = true
            UserDefaults.standard.set(colorsLang.rawValue, forKey: "colorsLang")
        }
    }
    
    @Published var showAlert: Bool = UserDefaults.standard.bool(forKey: "ShowAlert") {
        didSet {
            UserDefaults.standard.set(showAlert, forKey: "ShowAlert")
        }
    }
    
    init() {
        if !settingsChanged {
            // defaults
            leftHandMode = false
            tactileFeedback = true
            sounds = true
            colorsLang = Locale.current.languageCode == "ru" ? .russian : .english
            showAlert = true
        }
    }
}

struct SettingsView: View {
    
    @EnvironmentObject var settingsState: SettingsState
    
    let colorLangs = ["Русский", "English"]
    
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
                    Toggle("Left hand", isOn: $settingsState.leftHandMode)
                        .listRowBackground(Color.black)
                    Toggle("Tactile feedback", isOn: $settingsState.tactileFeedback)
                        .listRowBackground(Color.black)
                    Toggle("Sounds", isOn: $settingsState.sounds)
                        .listRowBackground(Color.black)
//                    Picker("Colors language", selection: $settingsState.colorsLang) {
//                        ForEach(ColorLang.allCases, id: \.self) { value in
//                            Text(value.rawValue.capitalized)
//                        }
//                    }
//                    .foregroundColor(.white)
//                    .listRowBackground(Color.black)
                }
                .padding()
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
