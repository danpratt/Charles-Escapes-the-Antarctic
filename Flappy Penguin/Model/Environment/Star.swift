//
//  Star.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/20/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

class Star: SKSpriteNode, GameSprite {
    
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "goods")
    var pulseAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 40, height: 38)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.powerup.rawValue
        // only one frame, so set it here
        texture = textureAtlas.textureNamed("star")
        run(pulseAnimation)
    }

    // MARK: - Animations
    
    private func createAnimations() {
        // scale star slightly smaller and fade, then make it bigger and remove fade
        // looping to give a pulse effect
        
        // first create pulse out animation
        let pulseOutGroup = SKAction.group([
                SKAction.fadeAlpha(to: 0.85, duration: 0.8),
                SKAction.scale(to: 0.6, duration: 0.8),
                SKAction.rotate(byAngle: -0.3, duration: 0.8)
            ])
        
        // then create pulse in animation
        let pulseInGroup = SKAction.group([
                SKAction.fadeAlpha(to: 1, duration: 1.5),
                SKAction.scale(to: 1, duration: 1.5),
                SKAction.rotate(byAngle: 3.5, duration: 1.5)
            ])
        
        // create sequence from both groups and loop forever
        let pulseSequence = SKAction.sequence([
                pulseOutGroup,
                pulseInGroup
            ])
        pulseAnimation = SKAction.repeatForever(pulseSequence)
    }

    func onTap() {
    }
    
    func collectStar() {
        // prevent further contact
        physicsBody?.categoryBitMask = 0
        // collect coin animation
        let collectAnimation = SKAction.group([
            SKAction.fadeAlpha(to: 0, duration: 0.2),
            SKAction.scale(to: 1.5, duration: 0.2),
            SKAction.move(by: CGVector(dx: 0, dy: 25), duration: 0.2)
            ])
        
        // move coin out of the way and reset to inital value until reused by enounter system
        let resetAfterCollected = SKAction.run {
            self.position.y = 5000
            self.alpha = 1
            self.xScale = 1
            self.yScale = 1
            self.physicsBody?.categoryBitMask = PhysicsCategory.powerup.rawValue
        }
        
        // combine into sequence
        let collectSequence = SKAction.sequence([
            collectAnimation,
            resetAfterCollected
            ])
        // run collection
        run(collectSequence)
    }
    
}
