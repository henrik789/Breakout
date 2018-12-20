//
//  StartScene.swift
//  Breakout
//
//  Created by Henrik on 2018-12-20.
//  Copyright © 2018 Henrik. All rights reserved.
//

import SpriteKit

class StartScene: SKScene{
    var red1 = 72.0
    var green1 = 84.0
    var blue1 = 96.0
    var red2 = 255.0
    var green2 = 192.0
    var blue2 = 72.0
    var scrollingBG: ScrollingBackground?
    var breakoutLogo = SKSpriteNode(imageNamed: "brick-wall2")
    let startLabel = SKLabelNode(text: "Start game")
    var gameScene:SKScene!
    
    override func didMove(to view: SKView) {
        
        let bgColor1 = UIColor(displayP3Red: CGFloat(red1 / 255.0), green: CGFloat(green1 / 255.0), blue: CGFloat(blue1 / 255.0), alpha: 1)
        backgroundColor = bgColor1
        let bgColor2 = UIColor(displayP3Red: CGFloat(red2 / 255.0), green: CGFloat(green2 / 255.0), blue: CGFloat(blue2 / 255.0), alpha: 1)
        
        scrollingBG = ScrollingBackground.scrollingNodeWithImage(imageName: "brick-wall", containerWidth: self.size.width)
        scrollingBG?.scrollingSpeed = 1.5
        scrollingBG?.anchorPoint = .zero
        
        self.addChild(scrollingBG!)
        
        startLabel.fontName = "Futura-MediumItalic"
        startLabel.fontSize = 70
        startLabel.fontColor = UIColor.white
        startLabel.zPosition = 2
        startLabel.position = CGPoint(x: size.width - (size.width * 0.5), y: size.height - (size.height * 0.85) )
        let scale = SKAction.scale(by: 0.95, duration: 0.4)
        let reverseScale = scale.reversed()
        let actions = [scale, reverseScale]
        let sequence = SKAction.sequence(actions)
        let repeatSequence = SKAction.repeatForever(sequence)
        startLabel.run(repeatSequence)
        addChild(startLabel)
        
        breakoutLogo.size = CGSize(width: size.width * 1, height: size.height * 1)
        breakoutLogo.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        breakoutLogo.zPosition = 1
        addChild(breakoutLogo)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == startLabel {
                let transition = SKTransition.fade(withDuration: 1)
//                gameScene = SKScene(fileNamed: "GameScene")
                let scene = GameScene(size: CGSize(width: 1334, height: 750))

                scene.scaleMode = .aspectFit
                self.view?.presentScene(scene, transition: transition)
                
            }
        }
    }
    
    
    
//    scene.scaleMode = .aspectFill
//
//    // Present the scene
//    if let view = self.view as! SKView? {
//        view.presentScene(scene)
//
//        view.ignoresSiblingOrder = true
//
//        view.showsFPS = true
//        view.showsNodeCount = true
    
    override func update(_ currentTime: TimeInterval) {
        if let scrollBG = self.scrollingBG {
            scrollBG.update(currentTime: currentTime)
        }
    }
    
    
}
