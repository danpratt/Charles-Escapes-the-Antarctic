//
//  Bee.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/18/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

class Bee: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "bee")
    var flyAnimation = SKAction()
    var flightPathAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 28, height: 24)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        run(flyAnimation)
        run(flightPathAnimation)
        
        // add physics engine
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
    }
    
    // TODO: - Setup onTap function
    
    func onTap() {
    }
    
    // Setup the flying animation
    private func createAnimations() {
        let beeFlyingFrames = [
            textureAtlas.textureNamed("bee"),
            textureAtlas.textureNamed("bee-fly")
        ]
        
        let randomX = CGFloat(arc4random_uniform(200))
        let randomSpeed = 100 / (Double(arc4random_uniform(75)) + 50)
        
        let flyLeft = SKAction.sequence([
                SKAction.moveBy(x: -randomX, y: 5, duration: randomSpeed),
                SKAction.scaleX(to: -1, duration: 0.3)
            ])
        let flyRight = SKAction.sequence([
                SKAction.moveBy(x: randomX, y: -5, duration: randomSpeed),
                SKAction.scaleX(to: 1, duration: 0.3)
            ])
        
        let flightPath = SKAction.repeatForever(SKAction.sequence([
                flyLeft,
                flyRight
            ]))
        
        let flyAction = SKAction.animate(with: beeFlyingFrames, timePerFrame: 0.14)
        
        flyAnimation = SKAction.repeatForever(flyAction)
        flightPathAnimation = SKAction.repeatForever(flightPath)
    }
    
}
