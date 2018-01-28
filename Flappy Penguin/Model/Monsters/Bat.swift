//
//  Bat.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/20/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

class Bat: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "bat")
    var flyAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 44, height: 24)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        
        // setup physics
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
        
        // add animations
        run(flyAnimation)
    }
    
    // MARK: - Animations
    
    // Create flying animation
    private func createAnimations() {
        let flyFrames: [SKTexture] = [
            textureAtlas.textureNamed("bat"),
            textureAtlas.textureNamed("bat-fly")
        ]
        
        let randomY = CGFloat(arc4random_uniform(75) + 25)
        let randomSpeed = Double(arc4random_uniform(3) + 1)
        
        let pathUp = SKAction.moveBy(x: 0, y: randomY, duration: randomSpeed)
        let pathDown = SKAction.moveBy(x: 0, y: -randomY, duration: randomSpeed)
        
        let flyPattern = SKAction.repeatForever(SKAction.sequence([
                pathUp,
                pathDown
            ]))
        
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.14)
        let loopedFlyAction = SKAction.repeatForever(flyAction)
        flyAnimation = SKAction.group([
                flyPattern,
                loopedFlyAction
            ])
        
        
    }
    
    func onTap() {
        
    }
    
}
