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
    
    
    override func didMove(to view: SKView) {
        
        
        print(phoneSize)

        setUpBricks()
        setupLabels()
        setupPhysics()

        
        
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
        
        
//        block.physicsBody!.allowsRotation = false
//        block.physicsBody!.friction = 0.0
//        block.physicsBody!.affectedByGravity = false
//        block.physicsBody!.isDynamic = false
//        block.name = "block"

//        print(block.size)
        
        var i = 0
        var row = 0.8


        for char in string1{
            
            
            switch  char{
            case "o":
                block = SKSpriteNode(imageNamed: "yellowBlock.png")
                block.position = CGPoint(x: xOffset + (CGFloat(i) * 1.1) * blockWidth,
                                         y: (frame.height * CGFloat(row)) + blockHeight)
                block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
                block.physicsBody!.categoryBitMask = BlockCategory
                block.zPosition = 2
                addChild(block)
//                block.run(animateOne(sequence))
                i += 1
                print("char: \(char, i)")
                print(numberOfBlocks, totalBlocksWidth, blockWidth, blockHeight, xOffset)
                
            case "-":
                block = SKSpriteNode(imageNamed: "orangeBlock.png")
                block.position = CGPoint(x: xOffset + (CGFloat(i) * 1.1) * blockWidth,
                                         y: (frame.height * CGFloat(row)) + blockHeight)
                block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
                block.physicsBody!.categoryBitMask = BlockCategory
//                block.physicsBody?.restitution = 1
                block.zPosition = 2
                addChild(block)
//                block.run(animateOne(sequence2))
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
    
    func setupLabels(){

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

        // 1.
        
        // 2.
        borderBody.friction = 0
        borderBody.restitution = 1
        // 3.
//        self.physicsBody = borderBody
    
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        

        let paddleRect = SKSpriteNode(imageNamed: "blue" )
//        let paddleRect = SKShapeNode(rectOf: CGSize(width: 160, height: 20))
        paddleRect.position = CGPoint(x: frame.width / 2, y: frame.height * 0.1)
//        paddleRect.lineWidth = 1
//        paddleRect.fillColor = .white
        paddleRect.physicsBody = SKPhysicsBody(rectangleOf: paddleRect.size)
        addChild(paddleRect)
        
        
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(10))
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.friction = 0.0
        ball.physicsBody!.affectedByGravity = true
        ball.physicsBody!.isDynamic = true
        ball.physicsBody!.angularDamping = 0
        ball.size = CGSize(width: 30, height: 30)
        ball.name = "ball"
        ball.zPosition = 2
        ball.position = CGPoint(x: size.width / 2,
                                 y: size.height * 0.5)
        addChild(ball)
        ball.physicsBody!.applyImpulse(CGVector(dx: 50.0, dy: 50.0))
        
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
            print("Hit bottom")
//            looseOneLife()
            // loose one life, pause countdown until ball is released from paddle
            
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory {
//            breakBlock(node: secondBody.node!)
            print("hitting blocks")
//            currentScore += 1
//            check if the game has been won
        }
        
        // 1
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BorderCategory {
            print("hit border")
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1
        if isFingerOnPaddle {
            // 2
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            // 3
            let paddle = SKSpriteNode(imageNamed: "blue")
            // 4
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            // 5
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            // 6
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnPaddle = false
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
        //        let ball = childNode(withName: "ball") as! SKSpriteNode
        //        let maxSpeed: CGFloat = 900.0
        //
        //        let xSpeed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx)
        //        let ySpeed = sqrt(ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
        //
        //        let speed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx + ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
        //
        //        if xSpeed <= 10.0 {
        //            ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: 0.0))
        //            print("x: " ,xSpeed)
        //        }
        //        if ySpeed <= 10.0 {
        //            ball.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: randomDirection()))
        //            print("y: ", ySpeed)
        //        }
        //
        //        if speed > maxSpeed {
        //            ball.physicsBody!.linearDamping = 0.4
        //            print("speed: ", speed)
        //        } else {
        //            ball.physicsBody!.linearDamping = 0.0
        //        }
        //
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
