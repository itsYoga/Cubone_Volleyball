//
//  MusicPlayer.swift
//  IOS Volleyball
//
//  Created by Jesse Liang on 2024/11/26.
//

import SwiftUI
import SpriteKit
import Observation
import AVFoundation
import UIKit

// 音樂播放控制
class MusicPlayer: ObservableObject {
    var player: AVAudioPlayer?
    
    func playMusic(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error loading music: \(error)")
        }
    }
    
    func stopMusic() {
        player?.stop()
    }
}
