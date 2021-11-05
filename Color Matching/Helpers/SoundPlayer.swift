//
//  SoundPlayer.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 30.08.2021.
//

import Foundation
import AVFoundation

class SoundPlayer {
    
    enum SoundType: String {
        case dragToRight = "drag_to_right"
        case dragToLeft = "drag_to_left"
        case tap = "tap"
        case tapHard = "tap_hard"
        case click = "click"
        case click2 = "click2"
        case swoosh = "swoosh"
        case spring = "spring"
        case swooshSpring = "swoosh-spring"
        case answerCorrect = "answer-correct"
        case answerWrong = "answer-wrong"
        case pop = "pop"
    }
    
    static let shared = SoundPlayer()
    
    var soundPlayer: AVAudioPlayer?
    var clockPlayer: AVAudioPlayer?
    var strikeHitPlayer: AVAudioPlayer?
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("coundn't initialize AVAudioSession settings")
        }
        
        let clockSoundPath = Bundle.main.path(forResource: "clock_tiking", ofType: "mp3")!
        let strikeSoundPath = Bundle.main.path(forResource: "strike", ofType: "mp3")!
        
        do {
            clockPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: clockSoundPath))
            clockPlayer?.prepareToPlay()
            
            strikeHitPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: strikeSoundPath))
            strikeHitPlayer?.prepareToPlay()
        }
        catch {
            print("coundn't get clock or strike sound")
        }
    }
    
    public func initialize() {
        soundPlayer?.prepareToPlay()
    }
    
    public func playSound(type: SoundType) {
        let path = Bundle.main.path(forResource: type.rawValue, ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.play()
        } catch {
            print("coundn't get sound file")
        }
    }
    
    public func playSoundAfterSeconds(type: SoundType, timer: Float) {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(timer), repeats: false) { _ in
            let path = Bundle.main.path(forResource: type.rawValue, ofType: "mp3")!
            let url = URL(fileURLWithPath: path)
            
            do {
                self.soundPlayer = try AVAudioPlayer(contentsOf: url)
                self.soundPlayer?.play()
            } catch {
                print("coundn't get sound file")
            }
        }
    }
    
    public func playStrikeHit(afterSeconds timer: Float) {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(timer), repeats: false) { _ in
            self.strikeHitPlayer?.play()
        }
    }
    
    public func playClockTiking() {
        if let clockPlaying = clockPlayer?.isPlaying {
            if !clockPlaying {
                clockPlayer?.play()
            }
        }
    }
    
    public func stopClockTiking() {
        clockPlayer?.stop()
    }
}
 
