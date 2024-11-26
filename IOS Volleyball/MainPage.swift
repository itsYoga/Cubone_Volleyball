import SwiftUI
import SpriteKit
import Observation
import AVFoundation
import UIKit
import Foundation


// MainPage.swift
struct MainPage: View {
    @State private var isGameStarted = false // 控制是否顯示遊戲頁面
    @State private var showTutorial = false // 控制是否顯示教學頁面
    @StateObject private var controller = GameController() // 創建 GameController 實例

    var body: some View {
        VStack {
            if showTutorial {
                // 教學頁面
                TutorialView(showTutorial: $showTutorial)
            } else if isGameStarted {
                // 遊戲頁面
                ContentView()
                    .environmentObject(controller) // 傳遞 GameController 給 ContentView
            } else {
                // 主畫面
                Text("Volleyball Game")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                VStack(spacing: 20) {
                    Button("Tutorial") {
                        showTutorial = true // 顯示教學頁面
                    }
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button("Start Game") {
                        isGameStarted = true // 切換到遊戲頁面
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 讓畫面佔滿全螢幕
    }
}

// 教學頁面
struct TutorialView: View {
    @Binding var showTutorial: Bool // 綁定變數以控制顯示狀態

    var body: some View {
        ZStack {
            // 背景圖片設為全螢幕
            Image("Tutorial")
                .resizable()
                .scaledToFill() // 圖片全螢幕顯示，填滿螢幕
                .edgesIgnoringSafeArea(.all) // 擴展至螢幕邊緣

            // 返回按鈕
            VStack {
                HStack {
                    Spacer()

                    Button {
                        showTutorial = false // 返回主頁
                    } label: {
                        Image(systemName: "house.fill")
                            .font(.title)
                            .padding()
                            .background(Circle().fill(Color.white))
                            .foregroundColor(.black)
                            .position(x: 10, y: 40)
                        
                    }
                }
                Spacer()
            }
        }
    }
}

// 預覽
struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
            .environmentObject(GameController()) // Inject GameController
            .environmentObject(MusicPlayer())    // Inject MusicPlayer
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDevice("iPhone 16 Pro")
    }
}

// App 入口
@main
struct VolleyballGameApp: App {
    @StateObject private var gameController = GameController()

    var body: some Scene {
        WindowGroup {
            MainPage()
                .environmentObject(MusicPlayer())
                .environmentObject(GameController()) // 確保傳遞必要的
        }
    }
}

struct VolleyballGameApp_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
            .environmentObject(MusicPlayer())
            .environmentObject(GameController()) // 使用新的 GameController 進行預覽
            .previewDevice("iPhone 16 Pro")
            .previewInterfaceOrientation(.landscapeLeft) // 如果需要可以設置橫向
    }
}
