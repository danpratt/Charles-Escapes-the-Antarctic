//
//  Ghost.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/20/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

class Ghost: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "ghost")
    var fadeAnimation = SKAction()
    var circleAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 30, height: 44)) {
        parentNode.addChild(self)
        self.size = size
        self.position = position
        createAnimations()
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
        texture = textureAtlas.textureNamed("ghost")
        run(fadeAnimation)
        run(circleAnimation)
        // start semi-transparent
        alpha = 0.8
    }
    
    // MARK: - Animations
    
    // create ghost's normal "glowing" animation
    private func createAnimations() {
        let fadeOutGroup = SKAction.group([
                SKAction.fadeAlpha(to: 0.3, duration: 2),
                SKAction.scale(to: 0.8, duration: 2)
            ])
        
        let fadeInGroup = SKAction.group([
                SKAction.fadeAlpha(to: 0.8, duration: 2),
                SKAction.scale(to: 1, duration: 2)
            ])
        
        let fadeSequence = SKAction.sequence([
                fadeOutGroup,
                fadeInGroup
            ])
        
        let randomDuration = Double(arc4random_uniform(4) + 3)
        
        let circlePath = UIBezierPath(arcCenter: position, radius: 80, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
        
        let circleAction = SKAction.follow(circlePath.cgPath, asOffset: false, orientToPath: false, duration: randomDuration)
        
        fadeAnimation = SKAction.repeatForever(fadeSequence)
        circleAnimation = SKAction.repeatForever(circleAction)
    }
    
    func onTap() {
        
    }
}
