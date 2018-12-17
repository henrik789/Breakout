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
    var isFingerOnPaddle = false
    let paddleRect = SKShapeNode(rectOf: CGSize(width: 160, height: 20))
    
    let livesLabel = SKLabelNode(text: "Lives:")
    var lives: Int = 3{
        didSet{
            livesLabel.text = "Lives: \(Int(lives))"
        }
    }
    let timerLabel = SKLabelNode(text: "Timer:")
    var remainingTime: TimeInterval = 60{
        didSet{
            timerLabel.text = "Timer: \(Int(remainingTime))"
        }
    }
    let scoreLabel = SKLabelNode(text: "Score:")
    var currentScore: Int = 0{
        didSet{
            scoreLabel.text = "Score: \(currentScore)"
        }
    }

    
    override func didMove(to view: SKView) {
        
        if(lives > 0){
            setUpBricks()
            remainingTime = 60
            gameTimer()
        }
        
        
        print(phoneSize)
        setupLabels()
        setupPhysics()
        preventsBallToGetStuck()
        
        
    }
    
    
    func setUpBricks(){
        
        
        let string1 =   """
                        -_o-o_-,
                        o-_o_-o,
                        -_o-o_-
                        """
        
//        let numberOfBlocks = Int(string1.count)
        let blockWidth = SKSpriteNode(imageNamed: "yellowBlock.png").size.width
        let blockHeight = SKSpriteNode(imageNamed: "yellowBlock.png").size.height
//        let totalBlocksWidth = blockWidth * CGFloat(numberOfBlocks / 2)
        let xOffset = (frame.width - (blockWidth * 6)) / 2
        let yOffset = frame.height * 0.95
        var index = 1
        var block = SKSpriteNode(imageNamed: "yellowBlock.png")
        
        
        block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
        block.physicsBody!.allowsRotation = false
        block.physicsBody!.friction = 0.0
        block.physicsBody!.affectedByGravity = false
        block.physicsBody!.isDynamic = false
        block.name = "block"
        block.physicsBody!.categoryBitMask = BlockCategory
        block.zPosition = 2
//        addChild(block)
        

        
        var i = 0
//        var row = 0.8


        for char in string1{
            
            
            switch  char{
            case "o":
                block = SKSpriteNode(imageNamed: "yellowBlock.png")
                block.position = CGPoint(x: xOffset + (CGFloat(i) * blockWidth),
                                         y: (yOffset - (blockHeight * CGFloat(index))))
                block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
                block.physicsBody!.categoryBitMask = BlockCategory
                block.physicsBody?.isDynamic = false
                block.zPosition = 2
                addChild(block)
//                block.run(animateOne(sequence))
                i += 1
//                print("char: \(char, i)")
//                print(numberOfBlocks, totalBlocksWidth, blockWidth, blockHeight, xOffset)
                
            case "-":
                block = SKSpriteNode(imageNamed: "orangeBlock.png")
                block.position = CGPoint(x: xOffset + (CGFloat(i) * blockWidth),
                                         y: (yOffset - (blockHeight * CGFloat(index))))
                block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
                block.physicsBody!.categoryBitMask = BlockCategory
                block.physicsBody?.isDynamic = false
//                block.physicsBody?.restitution = 1
                block.zPosition = 2
                addChild(block)
//                block.run(animateOne(sequence2))
                i += 1
                print(block.position.y)
                print("char: \(char, i, yOffset, xOffset)")
            case ",":
//                row = 0.7
                i = 0
                index += 1
            case "_":
                let emptyBlock = SKShapeNode(rectOf: CGSize(width: block.size.width, height: block.size.height))
                emptyBlock.position = CGPoint(x: xOffset + (CGFloat(i) * blockWidth),
                                         y: (yOffset - (blockHeight * CGFloat(index))))
                emptyBlock.lineWidth = 0
                addChild(emptyBlock)
                i += 1
            default:
                break
                
            }
        }

    }
    
    func setupLabels(){
        
        if(phoneSize.width >= 800){
            livesLabel.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.25) )
            addChild(livesLabel)
            timerLabel.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.15))
            addChild(timerLabel)
            scoreLabel.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.2) )
            addChild(scoreLabel)
        }else{
            livesLabel.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.15) )
            addChild(livesLabel)
            timerLabel.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.05))
            addChild(timerLabel)
            scoreLabel.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.1) )
            addChild(scoreLabel)
        }
    
    }
    
    func preventsBallToGetStuck(){
        
//        let ball = SKSpriteNode(imageNamed: "ball")
//        var xSpeed = ball.physicsBody?.velocity.dx
//        print(xSpeed as Any)
//
    }

    
    func setupPhysics(){
        var borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        let screenSize = CGRect(x: 0, y: 0, width: phoneSize.width * 0.75, height: phoneSize.height * 0.9 )
        if phoneSize.width < 800{
            borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
            self.physicsBody = borderBody
            print("smallscreen: \(self.frame)")
            print("borderbody: \(borderBody)")
            
        }else if(phoneSize.width > 800){
            borderBody = SKPhysicsBody(edgeLoopFrom: screenSize)
            self.physicsBody = borderBody
            print("screensize: \(screenSize)")
            print("borderbody: \(borderBody)")
            
        }

        borderBody.friction = 0
        borderBody.restitution = 1

//        self.physicsBody = borderBody
    
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        physicsWorld.contactDelegate = self
        

//        let paddleRect = SKSpriteNode(imageNamed: "blue" )
        
        paddleRect.position = CGPoint(x: frame.width / 2, y: frame.height * 0.1 )
        paddleRect.lineWidth = 2
        paddleRect.strokeColor = .yellow
        paddleRect.fillColor = .red
        paddleRect.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 160, height: 30))
        paddleRect.physicsBody?.isDynamic = false
        addChild(paddleRect)
        
        
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(10))
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.friction = 0.0
        ball.physicsBody!.affectedByGravity = false
        ball.physicsBody!.isDynamic = true
        ball.physicsBody!.angularDamping = 0
        ball.size = CGSize(width: 30, height: 30)
        ball.name = "ball"
        ball.zPosition = 2
        ball.position = CGPoint(x: size.width / 2,
                                 y: size.height * 0.5)
        addChild(ball)
        ball.physicsBody!.applyImpulse(CGVector(dx: 10.0, dy: 20.0))
        
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        
        borderBody.categoryBitMask = BorderCategory
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        paddleRect.physicsBody!.categoryBitMask = PaddleCategory
        ball.physicsBody!.contactTestBitMask = BottomCategory | BlockCategory | BorderCategory | PaddleCategory
        
//        let trailNode = SKNode()
//        trailNode.zPosition = 1
//        addChild(trailNode)
//
//        let trail = SKEmitterNode(fileNamed: "BallTrail")!
//        trail.targetNode = trailNode
//        ball.addChild(trail)
//
    }
    
//    func animateOne(){
//        let zoomIn = SKAction.scale(to: 1.5, duration: 0.35)
//        let zoomUp = SKAction.scale(to: 1, duration: 0.35)
//        let zoomOut = SKAction.scale(to: 0.25, duration: 0.35)
//        let wait = SKAction.wait(forDuration: 0.35)
//        let sequence = SKAction.sequence([zoomIn, wait, zoomUp, wait,  zoomIn, wait, zoomUp])
//        let sequence2 = SKAction.sequence([zoomOut, wait, zoomUp, wait, zoomOut, wait, zoomUp])
//    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
//        let ball = SKSpriteNode(imageNamed: "ball")
        
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
//            print("Hit bottom")
//            looseOneLife()
            lives -= 1
            // loose one life, pause countdown until ball is released from paddle
            
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory {
            breakBlock(node: secondBody.node!)
//            print("hitting blocks")
            currentScore += 1
//            check if the game has been won
        }
        
        // 1
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BorderCategory {
//            print("hit border")
        }
        
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == PaddleCategory {
            print("hit paddle")
        }
    }
    

    func breakBlock(node: SKNode) {
        let particles = SKEmitterNode(fileNamed: "BrokenPlatform")!
        particles.position = node.position
        particles.zPosition = 3
        addChild(particles)
        particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                         SKAction.removeFromParent()]))
        node.removeFromParent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
           
            paddleRect.run(SKAction.moveTo(x: location.x, duration: 0.2))
            print("touch")
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let paddleRect = SKSpriteNode(imageNamed: "blue" )
            paddleRect.run(SKAction.moveTo(x: location.x, duration: 0.2))
            print("moved")
        }
    }
    
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        // 1
////        if isFingerOnPaddle {
//            // 2
//            let touch = touches.first
//            let touchLocation = touch!.location(in: self)
//            let previousLocation = touch!.previousLocation(in: self)
//            // 3
//            let paddleRect = SKSpriteNode(imageNamed: "blue")
//            // 4
//            var paddleX = paddleRect.position.x + (touchLocation.x - previousLocation.x)
//            // 5
//            paddleX = max(paddleX, paddleRect.size.width/2)
//            paddleX = min(paddleX, size.width - paddleRect.size.width/2)
//            // 6
//            paddleRect.position = CGPoint(x: paddleX, y: paddleRect.position.y)
//            print("touch")
////        }
//    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnPaddle = false
    }
    
    func gameTimer(){
        
        let timeAction = SKAction.repeatForever(SKAction.sequence([SKAction.run ({
            self.remainingTime -= 1
        }), SKAction.wait(forDuration: 1)]))
        timerLabel.run(timeAction)
        print(remainingTime)
    }
    
    func randomFloat(from: CGFloat, to: CGFloat) -> CGFloat {
        let rand: CGFloat = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        return (rand) * (to - from) + from
    }
    
    func randomDirection() -> CGFloat {
        let speedFactor: CGFloat = 3.0
        if randomFloat(from: 0.0, to: 100.0) >= 50 {
            return -speedFactor
        } else {
            return speedFactor
        }
    }
    
    override func update(_ currentTime: TimeInterval) {

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
