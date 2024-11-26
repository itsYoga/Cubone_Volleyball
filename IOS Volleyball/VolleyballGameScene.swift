//
//  VolleyballGameScene.swift
//  IOS Volleyball
//
//  Created by Jesse Liang on 2024/11/26.
//

import SwiftUI
import SpriteKit
import Observation
import AVFoundation
import UIKit


// SpriteKit Game Scene for volleyball
class VolleyballGameScene: SKScene, SKPhysicsContactDelegate {
    var player1: SKSpriteNode!  // Player 1
    var player2: SKSpriteNode!  // Player 2
    var ball: SKSpriteNode!     // Volleyball
    var lastTouchPlayer: String? = nil // The player who last touched the ball
    var isGameStarted = false // Flag to ensure the game starts only after serve
    var isCountdownStarted = false // 是否啟動倒數計時
    var player1Score = 0  // Player 1 score
    var player2Score = 0  // Player 2 score
    var gameTimeRemaining = 30 // Game time in seconds
    var scoreLabel: SKLabelNode!  // Score label to show the score
    var countdownLabel: SKLabelNode!  // Countdown timer label
    var winnerLabel: SKLabelNode?
    var pastScores: [(player1Score: Int, player2Score: Int)] = [] // Record past match scores

    // 倒數計時初始化
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        setupCourt()
        setupPlayers()
        setupBall()
        setupScoreLabel()
        setupCountdownLabel()
        
        // Add trail setup for ball
        setupBallTrail()
    }
    
    // Setup the countdown timer label
    func setupCountdownLabel() {
        // 添加背景框架
        let background = SKShapeNode(rectOf: CGSize(width: 120, height: 40), cornerRadius: 10)
        background.fillColor = .darkGray
        background.strokeColor = .white
        background.position = CGPoint(x: self.size.width / 2, y: 330)
        addChild(background)

        // 倒數計時器文字
        countdownLabel = SKLabelNode(text: "Time: 30")
        countdownLabel.position = CGPoint(x: 0, y: -10)
        countdownLabel.fontSize = 24
        countdownLabel.fontColor = .white
        countdownLabel.fontName = "Lato-Regular"
        background.addChild(countdownLabel)
    }
    
    // Setup court with ground and net
    func setupCourt() {
        // Ground
        let ground = SKSpriteNode(color: .gray, size: CGSize(width: self.size.width, height: 50))
        ground.position = CGPoint(x: self.size.width / 2, y: 25)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false // Ground is static
        ground.name = "ground"
        addChild(ground)
        
        // Net
        let net = SKSpriteNode(color: .white, size: CGSize(width: 10, height: 120))
        net.position = CGPoint(x: self.size.width / 2, y: 110) // Position of the net
        net.physicsBody = SKPhysicsBody(rectangleOf: net.size)
        net.physicsBody?.isDynamic = false // Net is static
        net.physicsBody?.contactTestBitMask = 1 // Set contact test mask
        net.name = "net"
        addChild(net)
    }
    
    // Setup two players
    func setupPlayers() {
        // Player 1
        player1 = SKSpriteNode(imageNamed: "Player1") // 使用名為 cubone 的圖片
        player1.size = CGSize(width: 100, height: 100)
        player1.position = CGPoint(x: self.size.width * 0.25, y: 100)
        player1.physicsBody = SKPhysicsBody(texture: player1.texture!, size: player1.size) // 根據圖片設置物理邊界
        player1.physicsBody?.allowsRotation = false // Prevent rotation
        player1.physicsBody?.restitution = 0.1 // Bounciness
        player1.physicsBody?.friction = 0.3// Friction
        player1.physicsBody?.contactTestBitMask = 1
        player1.name = "player1"
        addChild(player1)
        
        // Player 2
        player2 = SKSpriteNode(imageNamed: "Player2") // 使用名為 cubone 的圖片
        player2.size = CGSize(width: 100, height: 100)
        player2.position = CGPoint(x: self.size.width * 0.75, y: 100)
        player2.physicsBody = SKPhysicsBody(texture: player2.texture!, size: player2.size) // 根據圖片設置物理邊界
        player2.physicsBody?.allowsRotation = false
        player2.physicsBody?.restitution = 0.1
        player2.physicsBody?.friction = 0.3
        player2.physicsBody?.contactTestBitMask = 1
        player2.name = "player2"
        addChild(player2)
    }
    
    let maxSpeed: CGFloat = 1000.0 // 定義最大速度

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)

        guard let physicsBody = ball.physicsBody else { return }
        
        if let ball = self.childNode(withName: "ball") as? SKSpriteNode {
            createTrailForBall(ball: ball)
        }        // 計算球的當前速度
        let velocity = CGVector(dx: physicsBody.velocity.dx, dy: physicsBody.velocity.dy)
        let speed = sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy)

        // 如果速度超過限制，縮放速度向量
        if speed > maxSpeed {
            let scale = maxSpeed / speed
            physicsBody.velocity = CGVector(dx: velocity.dx * scale, dy: velocity.dy * scale)
        }
    }
    
    
    // Setup the ball
    func setupBall() {
        ball = SKSpriteNode(imageNamed: "Ball") // Load the ball image
        ball.size = CGSize(width: 30, height: 30)
        ball.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        ball.physicsBody?.restitution = 0.01
        ball.physicsBody?.linearDamping = 0.5
        ball.physicsBody?.contactTestBitMask = 1
        ball.physicsBody?.isDynamic = false
        ball.name = "ball"
        addChild(ball)
    }
    
    func setupBallTrail() {
        // Assuming you have a reference to the ball (SKSpriteNode)
        if let ball = self.childNode(withName: "ball") as? SKSpriteNode {
            // Create the trail (you can use your custom particle file here)
            if let trail = SKEmitterNode(fileNamed: "BallTrail.sks") {
                trail.position = ball.position
                trail.targetNode = self
                ball.addChild(trail)
            }
        }
    }
    
    func createTrailForBall(ball: SKSpriteNode) {
        // Create a trail for the ball at its current position
        let trail = SKSpriteNode(color: .white, size: CGSize(width: 5, height: 5))
        trail.position = ball.position
        trail.alpha = 0.5  // Set transparency for the effect
        trail.zPosition = -1  // Ensure it appears behind the ball
        addChild(trail)
        
        // Add a fade-out and removal effect to the trail
        let fadeOutAction = SKAction.fadeAlpha(to: 0, duration: 0.3)
        let removeAction = SKAction.removeFromParent()
        
        trail.run(SKAction.sequence([fadeOutAction, removeAction]))
    }
    
    // Setup the score label with background
    func setupScoreLabel() {
        // 背景框架
        let scoreBackground = SKShapeNode(rectOf: CGSize(width: 150, height: 50), cornerRadius: 10)
        scoreBackground.position = CGPoint(x: self.size.width / 2, y: 370)
        scoreBackground.fillColor = .darkGray
        scoreBackground.strokeColor = .white
        addChild(scoreBackground)

        // 分數顯示，增加字型大小
        scoreLabel = SKLabelNode(text: "\(player1Score) - \(player2Score)") // 顯示純數字
        scoreLabel.position = CGPoint(x: 0, y: -10)
        scoreLabel.fontSize = 40  // 增加字型大小
        scoreLabel.fontColor = .white
        scoreLabel.fontName = "Lato-Bold"
        scoreBackground.addChild(scoreLabel)
    }
    
    func updateScoreLabel(animated: Bool = true) {
        scoreLabel.text = "\(player1Score) - \(player2Score)"

        guard animated else { return }

        // 計分動畫
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
        scoreLabel.run(SKAction.sequence([scaleUp, scaleDown])) // 計分動畫縮放效果
    }
    // Highlight the updated score with animation
    func animateScoreLabel() {
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
        scoreLabel.run(SKAction.sequence([scaleUp, scaleDown]))
    }
    
    func displayPastScores() {
        var scoreText = "Past Match Scores:\n"
        for (index, score) in pastScores.enumerated() {
            scoreText += "Match \(index + 1): Player 1: \(score.player1Score) - Player 2: \(score.player2Score)\n"
        }

        // 如果你有一個專門顯示歷史分數的label，可以將結果顯示在這裡
        winnerLabel?.text = scoreText  // 假設你有一個名為 winnerLabel 的 label 用來顯示這些分數
    }
    
    // 倒數計時更新
    func updateTimer() {
        if gameTimeRemaining > 0 {
            // 減少剩餘時間
            gameTimeRemaining -= 1
        } else if gameTimeRemaining == 0 {
            // 時間到後，呼叫 gameOver 函數來決定勝負或平手
            gameOver()
            gameTimeRemaining = -1 // 防止重複觸發 gameOver
            stopCountdown() // 停止倒數計時器
        }

        // 更新倒數計時器的文字
        countdownLabel.text = "Time: \(max(gameTimeRemaining, 0))"
    }

    // 停止倒數計時器
    func stopCountdown() {
        self.removeAction(forKey: "countdown") // 停止倒數計時器的動作
    }
    
    // Serve the ball
    func serveBall(from player: SKSpriteNode) {
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.velocity = .zero
        ball.position = CGPoint(x: player.position.x, y: player.position.y + 60)
        ball.physicsBody?.applyImpulse(CGVector(dx: player == player1 ? 50 : -50, dy: 80))
        isGameStarted = true
        lastTouchPlayer = player.name

        // Start countdown timer only when the game is served
        if !isCountdownStarted {
            isCountdownStarted = true
            startCountdownTimer() // Start countdown only once during serve
        }
    }
    
    func startCountdownTimer() {
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run { [weak self] in
                self?.updateTimer()
            }
        ])), withKey: "countdown") // 只有第一次 serve 時才會啟動
    }
    
    // Move the player
    func movePlayer(player: SKSpriteNode, dx: CGFloat) {
        player.position.x += dx
    }
    
    // Make the player jump
    func jumpPlayer(player: SKSpriteNode) {
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120)) // Apply an upward force

        // Change the texture when the player jumps
        if player.name == "player1" {
            player.texture = SKTexture(imageNamed: "Player1_Jump")
        } else if player.name == "player2" {
            player.texture = SKTexture(imageNamed: "Player2_Jump")
        }
    }
    
    // Handle collisions
    func didBegin(_ contact: SKPhysicsContact) {
        let sortedBodies = [contact.bodyA, contact.bodyB].sorted { $0.node?.name ?? "" < $1.node?.name ?? "" }
        
        if sortedBodies[0].node?.name == "ball" {
            var impulse = CGVector(dx: 0, dy: 50) // 預設的球反彈力量
            
            if let playerName = sortedBodies[1].node?.name, playerName == "player1" || playerName == "player2" {
                lastTouchPlayer = playerName // 更新最後觸球玩家
                
                // 獲取當前碰撞的玩家節點
                let player = sortedBodies[1].node as! SKSpriteNode
                
                // 檢查玩家是否正在跳躍
                if player.physicsBody?.velocity.dy ?? 0 > 0 {
                    // 玩家在跳躍中，根據玩家改變衝量的方向
                    if playerName == "player1" {
                        impulse = CGVector(dx: 20, dy: 2) // Player 1 跳躍觸碰
                    } else if playerName == "player2" {
                        impulse = CGVector(dx: -20, dy: 2) // Player 2 跳躍觸碰
                    }
                } else {
                    // 玩家未跳躍，應用正常的反彈邏輯
                    if playerName == "player1" {
                        impulse = CGVector(dx: 10, dy: 20) // Player 1 觸碰
                    } else if playerName == "player2" {
                        impulse = CGVector(dx: -10, dy: 20) // Player 2 觸碰
                    }
                }
                
                // 將計算出的衝量應用到球
                ball.physicsBody?.applyImpulse(impulse)
            } else if sortedBodies[1].node?.name == "ground" {
                // 如果球觸碰到地面，更新分數
                if ball.position.x < self.size.width / 2 {
                    // 左側地面：Player 2 得分
                    player2Score += 1
                    scoreLabel.text = " \(player1Score) - \(player2Score)"
                } else {
                    // 右側地面：Player 1 得分
                    player1Score += 1
                    scoreLabel.text = "Player 1: \(player1Score) - Player 2: \(player2Score)"
                }
                updateScoreLabel(animated: true)
                // 重置遊戲
                resetGame2()
            }
        }
        
        // 如果玩家與地面碰撞，重置玩家的圖片
        if sortedBodies[0].node?.name == "ground" {
            if sortedBodies[1].node?.name == "player1" {
                player1.texture = SKTexture(imageNamed: "Player1") // 重置 Player 1 的圖片
            } else if sortedBodies[1].node?.name == "player2" {
                player2.texture = SKTexture(imageNamed: "Player2") // 重置 Player 2 的圖片
            }
        }
    }
    
    

    // 修正計分板更新時不改變位置
    func gameOver() {
        // 停止遊戲
        isGameStarted = false
        pastScores.append((player1Score: player1Score, player2Score: player2Score))
        displayPastScores()
        
        // 判斷勝負並設置標籤文字
        if winnerLabel == nil {
            let winner: String = player1Score == player2Score ? "It's a tie!" : "\(player1Score > player2Score ? "Player 1" : "Player 2") wins!"
            winnerLabel = SKLabelNode(text: winner)
            winnerLabel?.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            winnerLabel?.fontSize = 40
            winnerLabel?.fontColor = .yellow
            addChild(winnerLabel!)
        }

        // 設定縮放動畫
        winnerLabel?.setScale(0) // 初始縮放為 0
        winnerLabel?.run(SKAction.scale(to: 1.0, duration: 0.5)) // 動畫縮放到正常大小

        // 移除球表示遊戲結束
        ball.removeFromParent()
    }
    
    
    // Reset the game state
    // 重設遊戲
    func resetGame() {
        isGameStarted = false
        isCountdownStarted = false // Ensure countdown doesn't start immediately
        gameTimeRemaining = 30 // Reset countdown timer
        player1Score = 0
        player2Score = 0

        // Remove winner label if it exists
        winnerLabel?.removeFromParent()
        winnerLabel = nil

        // Reset player positions
        player1.position = CGPoint(x: self.size.width * 0.25, y: 100)
        player2.position = CGPoint(x: self.size.width * 0.75, y: 100)

        // Reset ball
        if ball.parent == nil {
            setupBall()
        } else {
            ball.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            ball.physicsBody?.isDynamic = false // Stop ball's movement
            ball.physicsBody?.velocity = .zero // Reset velocity
        }

        // Update score label
        scoreLabel.text = "\(player1Score) - \(player2Score)"
    }
    
    func resetGame2() {
        isGameStarted = false
        isCountdownStarted = false // Stop countdown
        // Remove winner label if it exists
        winnerLabel?.removeFromParent()
        winnerLabel = nil

        // Reset player positions
        player1.position = CGPoint(x: self.size.width * 0.25, y: 100)
        player2.position = CGPoint(x: self.size.width * 0.75, y: 100)

        if ball.parent == nil {
            setupBall()
        } else {
            ball.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
            ball.physicsBody?.isDynamic = false
            ball.physicsBody?.velocity = .zero
        }
    }
}
