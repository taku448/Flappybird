//
//  GameScene.swift
//  FlappyBird
//
//  Created by 吉谷拓海 on 2020/06/21.
//  Copyright © 2020 takumi.yoshiya. All rights reserved.
//

import UIKit
import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scrollNode:SKNode!
    var wallNode:SKNode!
    var bird:SKSpriteNode!
    var birdNode:SKNode!
    var cherryNode:SKNode!
    
    
    
    
    let birdCategory: UInt32 = 1 << 0       // 0...00001
    let groundCategory: UInt32 = 1 << 1     // 0...00010
    let wallCategory: UInt32 = 1 << 2       // 0...00100
    let scoreCategory: UInt32 = 1 << 3      // 0...01000
    let itemCategory: UInt32 = 1 << 4       // 0...10000


    var score = 0
    var scoreLabelNode:SKLabelNode!
    
    var itemscore = 0
    var itemscoreLabelNode:SKLabelNode!
    
    var bestScoreLabelNode:SKLabelNode!
    let userDefaults:UserDefaults = UserDefaults.standard

    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -4)
        physicsWorld.contactDelegate = self
        
        backgroundColor = UIColor(red: 0.15, green: 0.75, blue: 0.90, alpha: 1)
        
        scrollNode = SKNode()
        addChild(scrollNode)
        
        wallNode = SKNode()
        scrollNode.addChild(wallNode)
        
        cherryNode = SKNode()
        scrollNode.addChild(cherryNode)
        
        setupCherry()
        setupGround()
        setupCloud()
        setupWall()
        setupBird()
        setupScoreLabel()
        setupItemScoreLabel()
        
    }
    
     func setupCherry() {
        
            
                let cherryTexture = SKTexture(imageNamed: "cherry")
                cherryTexture.filteringMode = .linear
            
            let wallTexture = SKTexture(imageNamed: "wall")
        wallTexture.filteringMode = .nearest
        
        
                let cherrymovingDistance = CGFloat(self.frame.size.width + cherryTexture.size().width)

        let moveCherry = SKAction.moveBy(x: -cherrymovingDistance, y: 0, duration:1)

                let removeCherry = SKAction.removeFromParent()

                let cherryAnimation = SKAction.sequence([moveCherry, removeCherry])

                let createCherryAnimation = SKAction.run({
                    
                    let sprite = SKSpriteNode(texture: cherryTexture)
                    
                    sprite.position = CGPoint(
                        x: self.frame.size.width + cherryTexture.size().width / 2,
                        y: self.frame.size.height / 2 )
                    
                    sprite.physicsBody = SKPhysicsBody(rectangleOf:
                        cherryTexture.size())
                    
                    sprite.physicsBody?.categoryBitMask = self.itemCategory
                    
                    sprite.physicsBody?.isDynamic = true
                    
                    sprite.run(cherryAnimation)
                    
                    
                    let cherryNode = SKNode()
                    cherryNode.position = CGPoint(
                        x: self.frame.size.width + cherryTexture.size().width / 2,
                        y: self.frame.size.height / 2)
                    
                    cherryNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cherryTexture.size().width,
                              height: self.frame.size.height))
                    
                    cherryNode.physicsBody?.isDynamic = false
                    cherryNode.physicsBody?.categoryBitMask = self.itemCategory
                    
                    cherryNode.physicsBody?.collisionBitMask = self.birdCategory
                    
                    
                    
                    
                    
                    
                    
                    
                    sprite.addChild(cherryNode)

                    self.cherryNode.addChild(sprite)
                    
                    
                    
                })
        

                // 次の壁作成までの時間待ちのアクションを作成
                let waitAnimation = SKAction.wait(forDuration: 1)
        
        

                // 壁を作成->時間待ち->壁を作成を無限に繰り返すアクションを作成
                let repeatForeverAnimation = SKAction.repeatForever(SKAction.sequence([createCherryAnimation, waitAnimation]))

        
        
                cherryNode.run(repeatForeverAnimation)
        
            
        
        
    }
    
    func setupGround() {
        
        let groundTexture = SKTexture(imageNamed: "ground")
        
        groundTexture.filteringMode = .nearest
        
        let needNumber = Int(self.frame.size.width / groundTexture.size().width) + 2
        
        let moveGround = SKAction.moveBy(x: -groundTexture.size().width , y: 0, duration: 5)
        
        let resetGround = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
        
        let repeatScrollGround = SKAction.repeatForever(SKAction.sequence([moveGround, resetGround]))
        
       for i in 0..<needNumber {
                   let sprite = SKSpriteNode(texture: groundTexture)
        
        sprite.position = CGPoint(
            x: groundTexture.size().width / 2 + groundTexture.size().width * CGFloat(i),
            y: groundTexture.size().height / 2
        )
        
        sprite.physicsBody = SKPhysicsBody(rectangleOf: groundTexture.size())
        sprite.physicsBody?.categoryBitMask = groundCategory
        
        sprite.physicsBody?.isDynamic = false
    
            sprite.run(repeatScrollGround)
            
            scrollNode.addChild(sprite)

    }
}
    
    func setupCloud() {
    let cloudTexture = SKTexture(imageNamed: "cloud")
    cloudTexture.filteringMode = .nearest

    let needCloudNumber = Int(self.frame.size.width / cloudTexture.size().width) + 2

    let moveCloud = SKAction.moveBy(x: -cloudTexture.size().width , y: 0, duration: 20)

    let resetCloud = SKAction.moveBy(x: cloudTexture.size().width, y: 0, duration: 0)

    let repeatScrollCloud = SKAction.repeatForever(SKAction.sequence([moveCloud, resetCloud]))

    for i in 0..<needCloudNumber {
        let sprite = SKSpriteNode(texture: cloudTexture)
        
        sprite.zPosition = -200

        sprite.position = CGPoint(
            x: cloudTexture.size().width / 2 + cloudTexture.size().width * CGFloat(i),
            y: self.size.height - cloudTexture.size().height / 2
        )

        sprite.run(repeatScrollCloud)

        scrollNode.addChild(sprite)
    }
}
        func setupWall() {
            
            let wallTexture = SKTexture(imageNamed: "wall")
            wallTexture.filteringMode = .nearest
            

            let movingDistance = CGFloat(self.frame.size.width + wallTexture.size().width)

            let moveWall = SKAction.moveBy(x: -movingDistance, y: 0, duration:4)

            let removeWall = SKAction.removeFromParent()

            let wallAnimation = SKAction.sequence([moveWall, removeWall])

            let birdSize = SKTexture(imageNamed: "bird_a").size()

            let slit_length = birdSize.height * 5

            let random_y_range = birdSize.height * 3

            let groundSize = SKTexture(imageNamed: "ground").size()
            
            let center_y = groundSize.height + (self.frame.size.height - groundSize.height) / 2
            let under_wall_lowest_y = center_y - slit_length / 2 - wallTexture.size().height / 2 - random_y_range / 2

            
            let createWallAnimation = SKAction.run({
            
                let wall = SKNode()
                wall.position = CGPoint(x: self.frame.size.width + wallTexture.size().width / 2, y: 0)
                wall.zPosition = -50

                let random_y = CGFloat.random(in: 0..<random_y_range)

                let under_wall_y = under_wall_lowest_y + random_y

                let under = SKSpriteNode(texture: wallTexture)
                
                under.position = CGPoint(x: 0, y: under_wall_y)
                
                under.physicsBody = SKPhysicsBody(rectangleOf: wallTexture.size())
                under.physicsBody?.categoryBitMask = self.wallCategory
                
                under.physicsBody?.isDynamic = false

                wall.addChild(under)

                let upper = SKSpriteNode(texture: wallTexture)
                upper.position = CGPoint(x: 0, y: under_wall_y + wallTexture.size().height + slit_length)
                
                upper.physicsBody = SKPhysicsBody(rectangleOf: wallTexture.size())
                upper.physicsBody?.categoryBitMask = self.wallCategory
                
                upper.physicsBody?.isDynamic = false
                
                wall.addChild(upper)

                let scoreNode = SKNode()
                scoreNode.position = CGPoint(x: upper.size.width + birdSize.width / 2, y: self.frame.height / 2)
                scoreNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: upper.size.width, height: self.frame.size.height))
                scoreNode.physicsBody?.isDynamic = false
                scoreNode.physicsBody?.categoryBitMask = self.scoreCategory
                scoreNode.physicsBody?.contactTestBitMask = self.birdCategory
                
            
                
                
                
                wall.addChild(scoreNode)
                
                wall.run(wallAnimation)

                self.wallNode.addChild(wall)
            })

            let waitAnimation = SKAction.wait(forDuration: 4)

            let repeatForeverAnimation = SKAction.repeatForever(SKAction.sequence([createWallAnimation, waitAnimation]))

            wallNode.run(repeatForeverAnimation)
            
                
            
        }

    func setupBird(){
        
        let birdTextureA = SKTexture(imageNamed: "bird_a")
        birdTextureA.filteringMode = .linear
        let birdTextureB = SKTexture(imageNamed: "bird_b")
        birdTextureB.filteringMode = .linear
        
        let texturesAnimation = SKAction.animate(with: [birdTextureA, birdTextureB], timePerFrame: 0.2)
        let flap = SKAction.repeatForever(texturesAnimation)

        bird = SKSpriteNode(texture: birdTextureA)
        bird.position = CGPoint(x: self.frame.size.width * 0.2, y:self.frame.size.height * 0.7)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        
        bird.physicsBody?.allowsRotation = false

        bird.physicsBody?.categoryBitMask = birdCategory
        bird.physicsBody?.collisionBitMask = groundCategory | wallCategory
        bird.physicsBody?.contactTestBitMask = groundCategory | wallCategory | itemCategory | scoreCategory
        
        
    
        
            bird.run(flap)
            
            addChild(bird)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if scrollNode.speed > 0 {
            
        bird.physicsBody?.velocity = CGVector.zero
        
            bird.physicsBody?.applyImpulse(CGVector(dx: 0.2, dy: 15))
        }else if bird.speed == 0 {
            restart()
        }
        
        }
    func didBegin(_ contact: SKPhysicsContact) {
        if scrollNode.speed <= 0 {
            return
        }
        
        if (contact.bodyA.categoryBitMask & scoreCategory) == scoreCategory || (contact.bodyB.categoryBitMask & scoreCategory) == scoreCategory  {
            
            print("scoreUp")
            
            score += 1
            scoreLabelNode.text = "Score:\(score)"
            
            self.cherryNode.removeAllChildren()
            
            var jump = SKAudioNode()
            jump = SKAudioNode(fileNamed: "jump01")
            addChild(jump)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 0.3秒後に実行したい処理 }}
                jump.removeFromParent()}
        }else
        
        
        if (contact.bodyA.categoryBitMask & itemCategory) == itemCategory || (contact.bodyB.categoryBitMask & itemCategory) == itemCategory  {
            
            print("Item scoreUp")
            
            itemscore += 1
            itemscoreLabelNode.text = "Item Score:\(itemscore)"
             
        
            
            self.cherryNode.removeAllChildren()
            
            var coin = SKAudioNode()
            coin = SKAudioNode(fileNamed: "coin01")
            addChild(coin)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 0.3秒後に実行したい処理 }}
                coin.removeFromParent()}
            
            var bestScore = userDefaults.integer(forKey: "BEST")
            if score > bestScore {
                bestScore = score
                bestScoreLabelNode.text = "Best Score:\(bestScore)"
                userDefaults.set(bestScore, forKey: "BEST")
                    userDefaults.synchronize()
                
            }
            

        }else {
            print("GameOver")
            
            scrollNode.speed = 0
            
            bird.physicsBody?.collisionBitMask = groundCategory
            
            let roll = SKAction.rotate(byAngle: CGFloat(Double.pi) * CGFloat(bird.position.y) * 0.01, duration:1)
            bird.run(roll, completion:{
                self.bird.speed = 0
            })
        }
    }
    func restart(){
        score = 0
        itemscore = 0
        scoreLabelNode.text = "Score:\(score)"
        itemscoreLabelNode.text = "Item Score:\(itemscore)"
        
        bird.position = CGPoint(x: self.frame.size.width * 0.2, y:self.frame.size.height * 0.7)
        bird.physicsBody?.velocity = CGVector.zero
        bird.physicsBody?.collisionBitMask = groundCategory | wallCategory
        bird.zRotation = 0

        wallNode.removeAllChildren()

        bird.speed = 1
        scrollNode.speed = 1
    }
    func setupItemScoreLabel() {
        
        itemscore = 0
        itemscoreLabelNode = SKLabelNode()
        itemscoreLabelNode.fontColor = UIColor.black
        itemscoreLabelNode.position = CGPoint(x: 10, y: self.frame.size.height - 120)
        itemscoreLabelNode.zPosition = 100
        itemscoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        itemscoreLabelNode.text = "Item Score:\(itemscore)"
        self.addChild(itemscoreLabelNode)

        
    }
    
    func setupScoreLabel(){
        
        score = 0
        scoreLabelNode = SKLabelNode()
        scoreLabelNode.fontColor = UIColor.black
        scoreLabelNode.position = CGPoint(x: 10, y: self.frame.size.height - 60)
        scoreLabelNode.zPosition = 100
        scoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabelNode.text = "Score:\(score)"
        self.addChild(scoreLabelNode)
        
        bestScoreLabelNode = SKLabelNode()
        bestScoreLabelNode.fontColor = UIColor.black
        bestScoreLabelNode.position = CGPoint(x: 10, y: self.frame.size.height - 90)
        bestScoreLabelNode.zPosition = 100
        bestScoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left

        let bestScore = userDefaults.integer(forKey: "BEST")
        bestScoreLabelNode.text = "Best Score:\(bestScore)"
        self.addChild(bestScoreLabelNode)
         
     }
    
    
    }
     
       
 
