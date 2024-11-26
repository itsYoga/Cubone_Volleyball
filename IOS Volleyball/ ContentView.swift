//
//   ContentView.swift
//  IOS Volleyball
//
//  Created by Jesse Liang on 2024/11/26.
//

import SwiftUI
import SpriteKit
import Observation
import AVFoundation
import UIKit

// SwiftUI ContentView
struct ContentView: View {
    @EnvironmentObject var controller: GameController
    @State private var showMusicView = false // 控制 sheet 的顯示
    @State private var showHistoryView = false // 控制歷史紀錄頁面的顯示
    @EnvironmentObject var musicPlayer: MusicPlayer
    
    var body: some View {
        ZStack {
            SpriteView(scene: controller.scene)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack {
                    // 控制玩家1的按鈕
                    VStack {
                        Button(action: {
                            controller.scene.movePlayer(player: controller.scene.player1, dx: -40)
                        }) {
                            Image("left") // 替換為你的圖片名稱
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        .frame(width: 50, height: 50)
                        .position(x: -20, y: 300)
                        
                        Button(action: {
                            controller.scene.jumpPlayer(player: controller.scene.player1)
                        }) {
                            Image("up") // 替換為你的圖片名稱
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        .frame(width: 50, height: 50)
                        .position(x: 15, y: 205)
                        
                        Button(action: {
                            controller.scene.movePlayer(player: controller.scene.player1, dx: 40)
                        }) {
                            Image("right") // 替換為你的圖片名稱
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        .frame(width: 50, height: 50)
                        .position(x: 50, y: 205)
                        
                        Button("Serve") {
                            if !controller.scene.isGameStarted {
                                controller.scene.serveBall(from: controller.scene.player1)
                            }
                        }
                        .frame(width: 60, height: 50)
                        .position(x:150, y: 220)
                        .foregroundColor(.white)
                        .font(.custom("Lato-Regular", size: 20))
                        
                    }
                    
                    Spacer()
                    
                    // 控制玩家2的按鈕
                    VStack {
                        Button(action: {
                            controller.scene.movePlayer(player: controller.scene.player2, dx: -40)
                        }) {
                            Image("left") // 替換為你的圖片名稱
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        .frame(width: 50, height: 50)
                        .position(x: 320, y: 300)
                        
                        Button(action: {
                            controller.scene.jumpPlayer(player: controller.scene.player2)
                        }) {
                            Image("up") // 替換為你的圖片名稱
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        .frame(width: 50, height: 50)
                        .position(x: 355, y: 205)
                    
                        Button(action: {
                            controller.scene.movePlayer(player: controller.scene.player2, dx: 40)
                        }) {
                            Image("right") // 替換為你的圖片名稱
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        .frame(width: 50, height: 50)
                        .position(x: 390, y: 205)
                        
                        Button("Serve") {
                            if !controller.scene.isGameStarted {
                                controller.scene.serveBall(from: controller.scene.player2)
                            }
                        }
                        .frame(width: 60, height: 50)
                        .position(x: 220, y: 220)
                        .foregroundColor(.white)
                        .font(.custom("Lato-Regular", size: 20))
                    }
                }
                
                HStack {
                    Button("Restart") {
                        controller.scene.resetGame()
                    }
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .font(.custom("Lato-Regular", size: 20))
                    .position(x: 375, y: 180)
                }
            }
            
            // 音樂控制按鈕放置於右上角
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showMusicView.toggle()  // 顯示音樂頁面
                    }) {
                        Image(systemName: "music.note")
                            .font(.title)
                            .padding()
                            .background(Circle().fill(Color.white))
                            .foregroundColor(.black)
                    }
                    .padding()
                    .sheet(isPresented: $showMusicView) {
                        MusicView().environmentObject(musicPlayer)  // 使用音樂控制頁面
                    }
                }
                .position(x: 400, y: 30)
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        showHistoryView.toggle()  // 顯示歷史頁面
                    }) {
                        Image(systemName: "clock.arrow.circlepath") // 替換為你想要的圖示
                            .font(.title)
                            .padding()
                            .background(Circle().fill(Color.white))
                            .foregroundColor(.black)
                    }
                    .padding()
                    .sheet(isPresented: $showHistoryView) {
                        HistoryView() // 顯示歷史紀錄頁面
                    }
                }
                .position(x: -310, y: -160)
                Spacer()
            }
        }
    }
}

struct HistoryView: View {
    var body: some View {
        VStack {
            Text("Game History")
                .font(.largeTitle)
                .bold()
            // Here you would display your game history data
            Text("Previous Scores / Events")
                .font(.title2)
                .padding()
            // For example, showing a list of game events
            List {
                Text("Game 1: Player 1 vs Player 2 - Score: 6-4")
            }
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MusicPlayer())
            .environmentObject(GameController()) // 確保傳遞必要的 environmentObject
            .previewDevice("iPhone 16 Pro")  // 可選：指定預覽設備
            .previewInterfaceOrientation(.landscapeLeft) // 設定橫向預覽
    }
}
