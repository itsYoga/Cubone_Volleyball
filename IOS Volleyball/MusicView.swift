//
//  MusicView.swift
//  IOS Volleyball
//
//  Created by Jesse Liang on 2024/11/26.
//

import SwiftUI
import SpriteKit
import Observation
import AVFoundation
import UIKit


// 音樂控制頁面
struct MusicView: View {
    @EnvironmentObject var musicPlayer: MusicPlayer
    
    // 音樂文件名稱列表
    let musicTracks = [
        "光あれ",
        "Ah Yeah!!",
        "FLY HIGH",
        "Imagination",
        "OST",
        "Phoenix"
    ]
    
    var body: some View {
        VStack {
            Text("Music")
                .font(.title)
                .padding()
            
            // 音樂列表
            List(musicTracks, id: \.self) { track in
                Button(track) {
                    musicPlayer.playMusic(named: track)
                }
                .padding()
                .foregroundColor(.black)
                .cornerRadius(10)
            }
            
            Button("Stop Music") {
                musicPlayer.stopMusic()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
    }
}
