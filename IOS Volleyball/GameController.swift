import SwiftUI
import SpriteKit
import Observation
import AVFoundation
import UIKit
import Foundation

// GameController 用來管理遊戲的狀態和歷史紀錄
class GameController: ObservableObject {
    @Published var scene: VolleyballGameScene
    @Published var showHistoryView = false  // 用來控制顯示歷史紀錄頁面
    @Published var pastScores: [(player1Score: Int, player2Score: Int)] = []  // 儲存歷史比賽的分數
    
    // 初始化
    init() {
        // 初始化場景
        let scene = VolleyballGameScene()
        scene.scaleMode = .fill
        
        // 根據屏幕尺寸設置場景大小
        let bounds = UIScreen.main.bounds
        if bounds.width > bounds.height {
            scene.size = CGSize(width: bounds.width, height: bounds.height) // 橫向
        } else {
            scene.size = CGSize(width: bounds.height, height: bounds.width) // 直向
        }
        
        self.scene = scene
    }
    
    // 更新場景大小以適應屏幕旋轉
    func updateSceneSize() {
        let bounds = UIScreen.main.bounds
        if bounds.width > bounds.height {
            scene.size = CGSize(width: bounds.width, height: bounds.height) // 橫向
        } else {
            scene.size = CGSize(width: bounds.height, height: bounds.width) // 直向
        }
    }
    
    // 觸發顯示歷史紀錄的視圖
    func toggleHistoryView() {
        showHistoryView.toggle()
    }
    
    // 更新歷史分數
    func addGameToHistory(player1Score: Int, player2Score: Int) {
        pastScores.append((player1Score: player1Score, player2Score: player2Score))
    }
}
