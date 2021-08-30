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
    }
    
    static let shared = SoundPlayer()
    
    var soundPlayer: AVAudioPlayer?
    var clockPlayer: AVAudioPlayer?
    
    init() {
        let path = Bundle.main.path(forResource: "clock_tiking", ofType: "mp3")!
        
        do {
            clockPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        }
        catch {
            print("coundn't get clock sound")
        }
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
 
