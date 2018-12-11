//
//  GameScene.swift
//  Breakout
//
//  Created by Henrik on 2018-12-10.
//  Copyright © 2018 Henrik. All rights reserved.
//  This is a Breakout game

import SpriteKit
import GameplayKit

let BallCategory   : UInt32 = 0x1 << 0
let BottomCategory : UInt32 = 0x1 << 1
let BlockCategory  : UInt32 = 0x1 << 2
let PaddleCategory : UInt32 = 0x1 << 3
let BorderCategory : UInt32 = 0x1 << 4

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var phoneSize = GameViewController.screensize

    
    override func didMove(to view: SKView) {

        backgroundColor = UIColor.gray
        
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
                    radius: 15,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        let ball = SKShapeNode(path: path)
        ball.lineWidth = 0.5
        ball.fillColor = .white
        ball.strokeColor = .yellow
        ball.glowWidth = 0.5
        ball.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5 )
        addChild(ball)

        setUpBricks()
        
        
//        setupLabels()
//        setupPhysics()

        let label1 = SKLabelNode(text: "Menu")
        let label2 = SKLabelNode(text: "Timer:")
        let label3 = SKLabelNode(text: "Score")
        if(phoneSize.width >= 800){
            label1.position = CGPoint(x: size.width - (size.width * 0.05), y: size.height - (size.height * 0.15) )
            addChild(label1)
            label2.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.15))
            addChild(label2)
            label3.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.2) )
            addChild(label3)
        }else{
            label1.position = CGPoint(x: size.width - (size.width * 0.05), y: size.height - (size.height * 0.05) )
            addChild(label1)
            label2.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.05))
            addChild(label2)
            label3.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.1) )
            addChild(label3)
        }
        
    }
    
    
    func setUpBricks(){
        
        
        let string1 =   """
                        -_o-o_-,
                        o-_o_-o
                        """
        
        let numberOfBlocks = Int(string1.count)
        let blockWidth = SKSpriteNode(imageNamed: "yellowBlock.png").size.width
        let blockHeight = SKSpriteNode(imageNamed: "yellowBlock.png").size.height
        let totalBlocksWidth = blockWidth * CGFloat(numberOfBlocks)
        let xOffset = (frame.width - (totalBlocksWidth / 2)) / 2
        var block = SKSpriteNode(imageNamed: "yellowBlock.png")
        block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
        block.physicsBody!.allowsRotation = false
        block.physicsBody!.friction = 0.0
        block.physicsBody!.affectedByGravity = false
        block.physicsBody!.isDynamic = false
        block.name = "block"
        block.physicsBody!.categoryBitMask = BlockCategory
        block.zPosition = 2
        var i = 0
        var row = 0.8


        for char in string1{
            
            
            switch  char{
            case "o":
                block = SKSpriteNode(imageNamed: "yellowBlock.png")
                block.position = CGPoint(x: xOffset + (CGFloat(i) * 1.1) * blockWidth,
                                         y: (frame.height * CGFloat(row)) + blockHeight)
                
                addChild(block)
                i += 1
                print("char: \(char, i)")
                print(numberOfBlocks, totalBlocksWidth, blockWidth, blockHeight, xOffset)
                
            case "-":
                block = SKSpriteNode(imageNamed: "orangeBlock.png")
                block.position = CGPoint(x: xOffset + (CGFloat(i) * 1.1) * blockWidth,
                                         y: (frame.height * CGFloat(row)) + blockHeight)
                addChild(block)
                i += 1
                print("char: \(char, i)")
            case ",":
                row = 0.7
                i = 0
            case "_":
                print("f")
                let emptyBlock = SKShapeNode(rectOf: CGSize(width: block.size.width, height: block.size.height))
                emptyBlock.position = CGPoint(x: xOffset + (CGFloat(i) * 1.1) * blockWidth,
                                         y: (frame.height * CGFloat(row)) + blockHeight)
                emptyBlock.lineWidth = 0
                addChild(emptyBlock)
                i += 1
            default:
                break
                
            }
        }
    }
    
//    func setupLabels(){
//
//        var livesLabel: SKLabelNode?
//        var lives: Int = 3{
//            didSet{
//                self.livesLabel?.text = "Lives: \(Int(self.lives))"
//            }
//        }
//
//
//        var timeLabel: SKLabelNode?
//        var remainingTime: TimeInterval = 60{
//            didSet{
//                self.timeLabel?.text = "Time: \(Int(self.remainingTime))"
//            }
//        }
//
//        var scoreLabel: SKLabelNode?
//        var currentScore: Int = 0{
//            didSet{
//                scoreLabel?.text = "Score: \(self.currentScore)"
//            }
//        }
//        scoreLabel = self.childNode(withName: "points") as? SKLabelNode
//        timeLabel = self.childNode(withName: "timer") as? SKLabelNode
//    }

    
    func setupPhysics(){
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        
        self.physicsBody = borderBody
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        
        let ball = childNode(withName: "ball") as! SKSpriteNode
        ball.physicsBody!.applyImpulse(CGVector(dx: 10.0, dy: 50.0))
        
        
        
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        let paddle = childNode(withName: "paddle") as! SKSpriteNode
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        borderBody.categoryBitMask = BorderCategory
        ball.physicsBody!.contactTestBitMask = BottomCategory | BlockCategory | BorderCategory | PaddleCategory
        
        let trailNode = SKNode()
        trailNode.zPosition = 1
        addChild(trailNode)
        
        let trail = SKEmitterNode(fileNamed: "BallTrail")!
        trail.targetNode = trailNode
        ball.addChild(trail)
        
    }
    

    
    
    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
//        if (self.lastUpdateTime == 0) {
//            self.lastUpdateTime = currentTime
//        }
//
//        // Calculate time since last update
//        let dt = currentTime - self.lastUpdateTime
//
//        // Update entities
//        for entity in self.entities {
//            entity.update(deltaTime: dt)
//        }
//
//        self.lastUpdateTime = currentTime
//    }
}
}



//        "__**____**__
//        __**________**"
//
//        position
//
//        for (tkn : string) {
//
//            if tkn == *
//                block = creat_block;
//                block.position = psoition;
//            if radbrytning
//                change position to new line
//
//            position += blocksize
//
//        }
