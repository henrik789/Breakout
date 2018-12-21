//
//  GameScene.swift
//  Breakout
//
//  Created by Henrik on 2018-12-10.
//  Copyright © 2018 Henrik. All rights reserved.
//  This is a Breakout game

import UIKit
import SpriteKit
import GameplayKit

let BallCategory   : UInt32 = 0x1 << 0
let BottomCategory : UInt32 = 0x1 << 1
let BlockCategory  : UInt32 = 0x1 << 2
let PaddleCategory : UInt32 = 0x1 << 3
let BorderCategory : UInt32 = 0x1 << 4

class GameScene: SKScene, SKPhysicsContactDelegate{
    var phoneSize = GameViewController.screensize
    var red1 = 54.0
    var green1 = 78.0
    var blue1 = 104.0
    
    var isFingerOnPaddle = false
    let paddleRect = SKShapeNode(rectOf: CGSize(width: 160, height: 20))
    let brickSound = SKAction.playSoundFileNamed("pongBlip.wav", waitForCompletion: false)
    let paddleSound = SKAction.playSoundFileNamed("paddleBlip.wav", waitForCompletion: false)
    let looseSound = SKAction.playSoundFileNamed("bottomHit.wav", waitForCompletion: false)

    let livesLabel = SKLabelNode(text: "Lives:")
    var lives: Int = 3{
        didSet{
            livesLabel.text = "Lives: \(Int(lives))"
            livesLabel.fontName = "Futura-MediumItalic"
            livesLabel.fontSize = 24
        }
    }
    let timerLabel = SKLabelNode(text: "Timer:")
    var remainingTime: TimeInterval = 60{
        didSet{
            timerLabel.text = "Timer: \(Int(remainingTime))"
            GameManager.sharedInstance.score = currentScore
            timerLabel.fontName = "Futura-MediumItalic"
            timerLabel.fontSize = 24
        }
    }
    let scoreLabel = SKLabelNode(text: "Score:")
    var currentScore: Int = 0{
        didSet{
            scoreLabel.text = "Score: \(currentScore)"
            scoreLabel.fontName = "Futura-MediumItalic"
            scoreLabel.fontSize = 24
        }
    }
    

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        
        setupPhysics()
//        setupBall()
        setupLabels()
        setBGColor()

        if(lives > 0){
            setUpBricks()
            remainingTime = 60
            gameTimer()
        }


        print(phoneSize)
        
        
    }
    
    
   
    func setBGColor(){
        let bgColor1 = UIColor(displayP3Red: CGFloat(red1 / 255.0), green: CGFloat(green1 / 255.0), blue: CGFloat(blue1 / 255.0), alpha: 1)
        backgroundColor = bgColor1

    }
    
    func setUpBricks(){
        
        let level1 =   """
                        -_o-o_-,
                        o-_o_-o,
                        -_o-o_-
                        """
        let level2 =   """
                        ooooooo,
                        -------,
                        --___--,
                        ooooooo
                        """

        if(lives < 4){
            
            let blockWidth = SKSpriteNode(imageNamed: "yellowBlock.png").size.width
            let blockHeight = SKSpriteNode(imageNamed: "yellowBlock.png").size.height
            let xOffset = (frame.width - (blockWidth * 6)) / 2
            let yOffset = frame.height * 0.95
            var index = 1
            var block = SKSpriteNode(imageNamed: "yellowBlock.png")
            setUpBricksPhysics()
            var i = 0
//            var canBuildBlock = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            
            for char in level2{
//                block.run(SKAction.sequence([SKAction.wait(forDuration: 0.4),
//                    SKAction.run { [weak self] in print("hej")
                switch (char) {
                case "o":
//                    canBuildBlock = true
                    block = SKSpriteNode(imageNamed: "yellowBlock.png")
                    block.position = CGPoint(x: xOffset + (CGFloat(i) * blockWidth),
                                             y: (yOffset - (blockHeight * CGFloat(index))))
                    block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
                    block.physicsBody!.categoryBitMask = BlockCategory
                    block.physicsBody?.isDynamic = false
                    block.zPosition = 2
//                    let wait = SKAction.wait(forDuration: 0.2)
//                    block.run(wait)


                    self.addChild(block)

                    i += 1
                    break
                    
                case "-":
                    block = SKSpriteNode(imageNamed: "orangeBlock.png")
                    block.position = CGPoint(x: xOffset + (CGFloat(i) * blockWidth),
                                             y: (yOffset - (blockHeight * CGFloat(index))))
                    block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
                    block.physicsBody!.categoryBitMask = BlockCategory
                    block.physicsBody?.isDynamic = false
                    block.zPosition = 2
                    self.addChild(block)
                    i += 1
                    break
                    
                case ",":
                    i = 0
                    index += 1
                    break
                    
                case "_":
                    let emptyBlock = SKShapeNode(rectOf: CGSize(width: block.size.width, height: block.size.height))
                    emptyBlock.position = CGPoint(x: xOffset + (CGFloat(i) * blockWidth),
                                             y: (yOffset - (blockHeight * CGFloat(index))))
                    emptyBlock.lineWidth = 0
                    self.addChild(emptyBlock)
                    i += 1
                    break
                    
                default:
                    break
                    }
//                    }]))
                }
            }

//        }
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

    
    func setUpBricksPhysics(){
        
        let block = SKSpriteNode(imageNamed: "yellowBlock.png")
        block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
        block.physicsBody!.allowsRotation = false
        block.physicsBody!.friction = 0.0
//        block.physicsBody!.affectedByGravity = false
        block.physicsBody!.isDynamic = false
        block.name = "block"
        block.physicsBody!.categoryBitMask = BlockCategory
        block.zPosition = 2
    }
    
    func setupPhysics(){
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(10))
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.friction = 0.0
        ball.physicsBody!.affectedByGravity = true
        ball.physicsBody!.isDynamic = true
        ball.physicsBody!.angularDamping = 0
        ball.size = CGSize(width: 30, height: 30)
        ball.zPosition = 2
        ball.physicsBody?.linearDamping = 0
        ball.position = CGPoint(x: size.width / 5,
                                y: size.height * 0.6)
        ball.name = "ball"
        ball.physicsBody!.contactTestBitMask = BottomCategory | BlockCategory | BorderCategory | PaddleCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        addChild(ball)
        ball.physicsBody!.applyImpulse(CGVector(dx: 10.0, dy: 15.0))

        let trailNode = SKNode()
        trailNode.zPosition = 2
        addChild(trailNode)
        
        let trail = SKEmitterNode(fileNamed: "BallTrail")!
        trail.targetNode = trailNode
        ball.addChild(trail)
//        var screenRect = CGRect(x: 0, y: 0, width: phoneSize.width, height: phoneSize.height)
        var borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
//        let screenSize = SKPhysicsBody(edgeLoopFrom: screenRect)
        
        let screenSize = CGRect(x: frame.origin.x, y: frame.origin.y + 50, width: frame.size.width, height: 630)
        if phoneSize.width < 800{
            borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
//            self.physicsBody = borderBody
            print("smallscreen: \(self.frame)")
            print("borderbody: \(borderBody)")

        }else if(phoneSize.width > 800){
            borderBody = SKPhysicsBody(edgeLoopFrom: screenSize )
//            self.physicsBody = borderBody
            print("screensize: \(screenSize)")
            print("borderbody: \(borderBody)")

        }

        borderBody.friction = 0
        borderBody.restitution = 1
        self.physicsBody = borderBody
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self

        let block = SKSpriteNode(imageNamed: "yellowBlock.png")
        block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
        block.physicsBody!.allowsRotation = false
        block.physicsBody!.friction = 0.0
        block.physicsBody!.affectedByGravity = false
        block.physicsBody!.isDynamic = false
        block.name = "block"
        block.physicsBody!.categoryBitMask = BlockCategory
        block.zPosition = 2
        
        paddleRect.position = CGPoint(x: frame.width / 2, y: frame.height * 0.1 )
        paddleRect.lineWidth = 2
        paddleRect.strokeColor = .white
        paddleRect.fillColor = .red
        paddleRect.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 160, height: 30))
        paddleRect.physicsBody?.isDynamic = false
        addChild(paddleRect)

        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        borderBody.categoryBitMask = BorderCategory
        bottom.physicsBody!.categoryBitMask = BottomCategory
        paddleRect.physicsBody!.categoryBitMask = PaddleCategory

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
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {

            self.run(looseSound)
            lives -= 1
            runAnimation()
            // loose one life, pause countdown until ball is released from paddle
            
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory {
            breakBlock(node: secondBody.node!)
            currentScore += 1
//            if isGameWon(){
//
//                ball.physicsBody!.linearDamping = 1.0
//                scene.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
//            }

            self.run(brickSound)
        }
        

        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BorderCategory {
//            print("hit border")

        }
        
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == PaddleCategory {
            print("hit paddle")
            self.run(paddleSound)
        }
    }
    

    func breakBlock(node: SKNode) {
        let scale = SKAction.scale(by: 0.8, duration: 0.1)
        let reverseScale = scale.reversed()
        let actions = [scale, reverseScale]
        let sequence = SKAction.sequence(actions)
        scoreLabel.run(sequence)
        let particles = SKEmitterNode(fileNamed: "BrokenPlatform")!
        particles.position = node.position
        particles.zPosition = 3
        addChild(particles)
        particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                         SKAction.removeFromParent()]))
        node.removeFromParent()
    }
    
    func runAnimation(){
        let scale = SKAction.scale(by: 0.8, duration: 0.1)
        let reverseScale = scale.reversed()
        let actions = [scale, reverseScale]
        let sequence = SKAction.sequence(actions)
        livesLabel.run(sequence)
    }
    
    
//    func isGameWon() -> Bool {
//
//        var numberOfBricks = 0
//        self.enumerateChildNodes(withName: "block") {
//            node, stop in
//            numberOfBricks = numberOfBricks + 1
//        }
//        return numberOfBricks == 0
//    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
           
            paddleRect.run(SKAction.moveTo(x: location.x, duration: 0.2))

        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            let paddleRect = SKSpriteNode(imageNamed: "blue" )
            paddleRect.run(SKAction.moveTo(x: location.x, duration: 0.2))

        }
    }
    
    

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
    
//    override func didEnter(from previousState: GKState?) {
//        if previousState is WaitingForTap {
//            let ball = scene.childNode(withName: BallCategoryName) as? SKSpriteNode
//            ball?.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: randomDirection()))
//        }
//    }
    
    override func update(_ currentTime: TimeInterval) {

        let ball = childNode(withName: "ball") as! SKSpriteNode
        let maxSpeed: CGFloat = 1300.0
        let xSpeed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx)
        let ySpeed = sqrt(ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)

        let speed = sqrt((ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx) + (ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy))

        if xSpeed <= 20.0 {
            ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: 0.0))
//            print("x: " ,xSpeed)
        }
        if ySpeed <= 10.0 {
            ball.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: randomDirection()))
//            print("y: ", ySpeed)
        }

        if speed > maxSpeed {
            ball.physicsBody!.linearDamping = 0.4
            print("speed: ", speed)
        } else {
            ball.physicsBody!.linearDamping = 0.0
        }
//        print("xSpeed: \(xSpeed) ySpeed: \(ySpeed)")
    }
    
}



//    func setupBall(){
//        let ball = SKSpriteNode(imageNamed: "ball")
//        ball.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(10))
//        ball.physicsBody!.restitution = 1
//        ball.physicsBody!.friction = 0.0
//        ball.physicsBody!.affectedByGravity = false
//        ball.physicsBody!.isDynamic = true
//        ball.physicsBody!.angularDamping = 0
//        ball.size = CGSize(width: 30, height: 30)
//        ball.zPosition = 2
////        ball.physicsBody?.mass = 0.008936
//        ball.physicsBody?.linearDamping = 0
//        ball.position = CGPoint(x: size.width / 5,
//                                y: size.height * 0.6)
//        ball.name = "ball"
//        ball.physicsBody!.applyImpulse(CGVector(dx: 30.0, dy: 50.0))
//
//
//        ball.physicsBody!.contactTestBitMask = BottomCategory | BlockCategory | BorderCategory | PaddleCategory
//        ball.physicsBody!.categoryBitMask = BallCategory
//        addChild(ball)
//        let trailNode = SKNode()
//        trailNode.zPosition = 2
//        addChild(trailNode)
//
//        let trail = SKEmitterNode(fileNamed: "BallTrail")!
//        trail.targetNode = trailNode
//        ball.addChild(trail)
//    }





//          667 / 375               375/667 =  0.56
//          896 / 414               414/896 =  0.46
//
