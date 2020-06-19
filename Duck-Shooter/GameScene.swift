//
//  GameScene.swift
//  Challenge6
//
//  Created by Rohit Lunavara on 6/14/20.
//  Copyright © 2020 Rohit Lunavara. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    //MARK: - UI Elements
    var woodBackground : SKSpriteNode!
    var curtains : SKSpriteNode!
    var grass : SKSpriteNode!
    var wavesBackground : SKSpriteNode!
    var wavesForeground : SKSpriteNode!
    var gameRules : SKLabelNode!
    var scoreLabel : SKLabelNode!
    var bulletImage : SKSpriteNode!
    var gameOverLabel : SKSpriteNode!
    var nextLevelLabel : SKLabelNode!
    var missesLabel : SKLabelNode!
    
    //MARK: - Sounds
    var empty = SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false)
    var reload = SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false)
    var shot = SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false)
    
    //MARK: - Game State
    var gameTimer : Timer!
    var gameSpeed = 0.75 {
        didSet {
            gameTimer.invalidate()
        }
    }
    var score = 0 {
        didSet {
            if score >= scoreToBeat {
                isGameStarted = false
            } else {
                scoreLabel.text = "Targets left : \(scoreToBeat - score)"
            }
        }
    }
    var scoreToBeat = 5
    var bullets = 3 {
        willSet {
            if newValue < 0 {
                run(empty)
                return
            }
            if newValue > bullets {
                run(reload)
                return
            }
            if newValue < bullets {
                run(shot)
                return
            }
        }
        didSet {
            if bullets >= 0 {
                bulletImage.texture = SKTexture(imageNamed: "shots\(bullets)")
            }
        }
    }
    var isGameStarted = true {
        didSet {
            if !isGameStarted {
                gameOver(restart: false)
            }
        }
    }
    var missesInRow = 0 {
        didSet {
            missesLabel.text = "Misses : \(missesInRow)"
            if missesInRow >= 3 {
                missesInRow = 0
                gameOver(restart: true)
            }
        }
    }
    var level = 1 {
        didSet {
            nextLevelLabel.text = "Level : \(level)"
        }
    }
    
}

//MARK: - UI Setup

extension GameScene {
    override func didMove(to view: SKView) {
        setupStage()
        setupStageAnimations()
    }
    
    func setupStage() {
        woodBackground = SKSpriteNode(imageNamed: "wood-background")
        woodBackground.position = CGPoint(x: 512, y: 384)
        woodBackground.blendMode = .replace
        woodBackground.zPosition = -4
        woodBackground.size = CGSize(width: view!.frame.width, height: view!.frame.height)
        addChild(woodBackground)
        
        grass = SKSpriteNode(imageNamed: "grass-trees")
        grass.position = CGPoint(x: 512, y: 384)
        grass.zPosition = -2
        grass.size.width = view!.frame.width
        addChild(grass)
        
        wavesBackground = SKSpriteNode(imageNamed: "water-bg")
        wavesBackground.position = CGPoint(x: 512, y: 288)
        wavesBackground.zPosition = 0
        wavesBackground.size.width = view!.frame.width
        addChild(wavesBackground)
        
        wavesForeground = SKSpriteNode(imageNamed: "water-fg")
        wavesForeground.position = CGPoint(x: 512, y: 192)
        wavesForeground.zPosition = 2
        wavesForeground.size.width = view!.frame.width
        addChild(wavesForeground)
        
        curtains = SKSpriteNode(imageNamed: "curtains")
        curtains.position = CGPoint(x: 512, y: 384)
        curtains.zPosition = 4
        curtains.size = CGSize(width: view!.frame.width, height: view!.frame.height)
        addChild(curtains)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 512, y: 60)
        scoreLabel.zPosition = 6
        score = 0
        addChild(scoreLabel)
        
        missesLabel = SKLabelNode(fontNamed: "Chalkduster")
        missesLabel.position = CGPoint(x: 512, y: 660)
        missesLabel.zPosition = 6
        missesInRow = 0
        addChild(missesLabel)
        
        bulletImage = SKSpriteNode(imageNamed: "shots3")
        bulletImage.setScale(2.5)
        bulletImage.position = CGPoint(x: 800, y: 75)
        bulletImage.zPosition = 6
        bulletImage.name = "Bullets"
        addChild(bulletImage)
        
        gameRules = SKLabelNode(fontNamed: "Chalkduster")
        gameRules.position = CGPoint(x: 512, y: 284)
        gameRules.fontColor = .black
        gameRules.horizontalAlignmentMode = .center
        gameRules.text = "Tap on the bullets to reload.\nIf you miss 3 times in a row, you lose.\nShoot to start!"
        gameRules.preferredMaxLayoutWidth = 400
        gameRules.numberOfLines = 4
        gameRules.zPosition = 8
        gameRules.name = "GameStart"
        addChild(gameRules)
        
        gameOverLabel = SKSpriteNode(imageNamed: "game-over")
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.zPosition = 8
        gameOverLabel.alpha = 0.0
        gameOverLabel.name = "GameOver"
        addChild(gameOverLabel)
        
        nextLevelLabel = SKLabelNode(fontNamed: "Chalkduster")
        nextLevelLabel.fontSize = 72
        nextLevelLabel.position = CGPoint(x: 512, y: 364)
        nextLevelLabel.zPosition = 6
        nextLevelLabel.alpha = 0.0
        nextLevelLabel.name = "NextLevel"
        level = 1
        addChild(nextLevelLabel)
        
        isGameStarted = true
    }
    
    func setupStageAnimations() {
        let woodBGForward = SKAction.moveBy(x: 40, y: 0, duration: 5)
        let woodBGBackward = SKAction.moveBy(x: -40, y: 0, duration: 5)
        let woodBGSequence = SKAction.sequence([woodBGForward, woodBGBackward])
        let woodBGForever = SKAction.repeatForever(woodBGSequence)
        woodBackground.run(woodBGForever)
        woodBackground.isPaused = true
        
        let wavesBGForward = SKAction.moveBy(x: 0, y: 40, duration: 1)
        let wavesBGBackward = SKAction.moveBy(x: 0, y: -40, duration: 1)
        let wavesBGSequence = SKAction.sequence([wavesBGForward, wavesBGBackward])
        let wavesBGForever = SKAction.repeatForever(wavesBGSequence)
        wavesBackground.run(wavesBGForever)
        wavesBackground.isPaused = true
        
        let wavesFGForward = SKAction.moveBy(x: 0, y: 20, duration: 0.75)
        let wavesFGBackward = SKAction.moveBy(x: 0, y: -20, duration: 0.75)
        let wavesFGSequence = SKAction.sequence([wavesFGForward, wavesFGBackward])
        let wavesFGForever = SKAction.repeatForever(wavesFGSequence)
        wavesForeground.run(wavesFGForever)
        wavesForeground.isPaused = true
    }
}

//MARK: - Animations

extension GameScene {
    
    func startAnimateStage() {
        gameOverLabel.run(SKAction.fadeOut(withDuration: 0.25))
        woodBackground.isPaused = false
        wavesBackground.isPaused = false
        wavesForeground.isPaused = false
    }
    
    func stopAnimateStage() {
        woodBackground.isPaused = true
        wavesBackground.isPaused = true
        wavesForeground.isPaused = true
    }
    
    func startGameOverAnimations(nextLevel : Bool) {
        if !nextLevel {
            gameOverLabel.run(SKAction.fadeIn(withDuration: 0.25))
        } else {
            nextLevelLabel.run(SKAction.fadeIn(withDuration: 0.25))
        }
        let scoreForward = SKAction.move(to: CGPoint(x: 512, y: 290), duration: 0.5)
        scoreForward.timingMode = .easeInEaseOut
        scoreLabel.run(scoreForward)
        let missesForward = SKAction.move(to: CGPoint(x: 512, y: 450), duration: 0.5)
        missesForward.timingMode = .easeInEaseOut
        missesLabel.run(missesForward)
    }
    
    func stopGameOverAnimations(nextLevel : Bool) {
        if !nextLevel {
            gameOverLabel.run(SKAction.fadeOut(withDuration: 0.25))
        } else {
            nextLevelLabel.run(SKAction.fadeOut(withDuration: 0.25))
        }
        let scoreBackward = SKAction.move(to: CGPoint(x: 512, y: 60), duration: 0.5)
        scoreBackward.timingMode = .easeInEaseOut
        scoreLabel.run(scoreBackward)
        let missesBackward = SKAction.move(to: CGPoint(x: 512, y: 660), duration: 0.5)
        missesBackward.timingMode = .easeInEaseOut
        missesLabel.run(missesBackward)
    }
}

//MARK: - Game Logic

extension GameScene {
    func startGame() {
        gameRules.run(SKAction.fadeAlpha(by: -1.0, duration: 0.5))
        startAnimateStage()
        setupTimer()
    }
    
    func gameOver(restart : Bool) {
        stopAnimateStage()
        stopTimer()
        killAllEnemies()
        
        if restart {
            resetGameState()
        }
        else {
            advanceLevel()
        }
    }
    
    func setupTimer() {
        if gameTimer != nil { gameTimer.invalidate() }
        gameTimer = Timer.scheduledTimer(timeInterval: gameSpeed, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        gameTimer.invalidate()
    }
    
    // Won
    func advanceLevel() {
        gameSpeed *= 0.95
        scoreToBeat += 5
        level += 1
        score = 0
        missesInRow = 0
        startGameOverAnimations(nextLevel : true)
    }
    
    // Lost
    func resetGameState() {
        startGameOverAnimations(nextLevel: false)
    }
    
    func restartGame(nextLevel advance : Bool) {
        stopGameOverAnimations(nextLevel : advance)
        isGameStarted = true
        if !advance {
            gameSpeed = 1.0
            scoreToBeat = 5
            level = 1
            score = 0
            missesInRow = 0
        }
        setupTimer()
        startAnimateStage()
    }
    
    @objc func createEnemy() {
        let target = Target()
        target.setup()
        target.name = "Target"
        
        let zPos = Int.random(in: -1...4)
        var targetMove : SKAction! = nil
        switch zPos {
        case -1, 0:
            target.setScale(0.7)
            target.zPosition = -1
            target.position = CGPoint(x: 10, y: 400)
            targetMove = SKAction.moveBy(x: 1300, y: 0, duration: Double.random(in: gameSpeed * 4 ... gameSpeed * 5))
            
        case 1, 2:
            target.setScale(0.85)
            target.xScale = -1.0
            target.zPosition = 1
            target.position = CGPoint(x: 1014, y: 300)
            targetMove = SKAction.moveBy(x: -1300, y: 0, duration: Double.random(in: gameSpeed * 3 ... gameSpeed * 4))
            
        case 3, 4:
            target.zPosition = 3
            target.position = CGPoint(x: 10, y: 200)
            targetMove = SKAction.moveBy(x: 1300, y: 0, duration: Double.random(in: gameSpeed * 2 ... gameSpeed * 3))
            
        default:
            break
        }
        
        if let targetMovement = targetMove {
            target.run(targetMovement)
        }
        addChild(target)
    }
    
    func remove(target node : SKNode) {
        let fade = SKAction.fadeOut(withDuration: 0.25)
        let drop = SKAction.moveBy(x: 0, y: -50, duration: 0.25)
        let rescale = SKAction.scaleX(by: 0.7, y: 0.5, duration: 0.25)
        let delay = SKAction.wait(forDuration: gameSpeed * 0.5)
        let remove = SKAction.run { [weak node] in
            node?.removeFromParent()
        }
        let sequence = SKAction.sequence([delay, remove])
        
        node.run(fade)
        node.run(drop)
        node.run(rescale)
        node.run(sequence)
    }
    
    func killAllEnemies() {
        for node in children {
            if node.name == "Target" {
                remove(target: node)
            }
        }
    }
    
    //MARK: - Per frame update handler
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            // Remove target when it is off-screen
            if node.name == "Target" {
                if node.position.x < 0 || node.position.x > 1024 {
                    let remove = SKAction.run { [weak node] in
                        node?.removeFromParent()
                    }
                    node.run(remove)
                    if isGameStarted { missesInRow += 1 }
                }
            }
        }
    }
    
    //MARK: - Per touch event handler
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        bullets -= 1
        for node in touchedNodes {
            // Start game
            if node.name == "GameStart" {
                startGame()
                return
            }
            
            // Restart game
            if node.name == "GameOver" {
                restartGame(nextLevel: false)
                return
            }
            
            // Next Level
            if node.name == "NextLevel" {
                restartGame(nextLevel: true)
                return
            }
            
            // Remove target if shot
            if node.name == "Target" && bullets >= 0 {
                remove(target: node)
                score += 1
                missesInRow = 0
                return
            }
            
            // Reload bullets
            if node.name == "Bullets" {
                bullets = 3
                return
            }
        }
    }
}
