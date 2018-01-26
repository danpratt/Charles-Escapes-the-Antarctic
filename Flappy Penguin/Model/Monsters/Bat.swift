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
        run(flyAnimation)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
    }
    
    // MARK: - Animations
    
    // Create flying animation
    private func createAnimations() {
        let flyFrames: [SKTexture] = [
            textureAtlas.textureNamed("bat"),
            textureAtlas.textureNamed("bat-fly")
        ]
        
        let randomX = CGFloat(arc4random_uniform(100))
        let randomBigY = CGFloat(arc4random_uniform(200))
        let randomSmallY = CGFloat(arc4random_uniform(30))
        let randomSpeed = Double(arc4random_uniform(150))
        
        let pathUp = SKAction.moveBy(x: -randomX, y: randomBigY, duration: randomSpeed)
        let pathRight = SKAction.moveBy(x: randomX, y: randomSmallY, duration: randomSpeed)
        let pathDown = SKAction.moveBy(x: -randomX, y: -100, duration: randomSpeed)
        
        let flyPattern = SKAction.repeatForever(SKAction.sequence([
                pathUp,
                pathRight,
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
