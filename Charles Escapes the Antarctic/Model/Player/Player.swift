//
//  Player.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/18/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode, GameSprite {
    
    // Texture Atlas
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "charles")
    
    // Animations
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 64, height: 64)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        
        self.run(flyAnimation, withKey: "flapAnimation")
        
        // setup physics body
        // use flying 3 image, because wings are tucked in
        let bodyTexture = textureAtlas.textureNamed("charles-flying-3")
        physicsBody = SKPhysicsBody(texture: bodyTexture, size: size)
        // loses momentum quickly
        physicsBody?.linearDamping = 0.9
        // set mass to be close to a real penguin
        physicsBody?.mass = 30
        // prevent rotating
        physicsBody?.allowsRotation = false
    }
    
    // MARK: - Update Function
    func update() {
        
    }
    
    // MARK: - OnTap Function
    
    func onTap() {
        
    }
    
    // MARK: - CreateAnimations()
    private func createAnimations() {
        // rotate up animation
        let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
        rotateUpAction.timingMode = .easeOut
        
        // rotate down animation
        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.8)
        rotateDownAction.timingMode = .easeOut
        
        // create flying animation
        let flyFrames: [SKTexture] = [
            textureAtlas.textureNamed("charles-flying-1"),
            textureAtlas.textureNamed("charles-flying-2"),
            textureAtlas.textureNamed("charles-flying-3"),
            textureAtlas.textureNamed("charles-flying-4"),
            textureAtlas.textureNamed("charles-flying-3"),
            textureAtlas.textureNamed("charles-flying-2")
        ]
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.03)
        
        // create rotating up flying animation
        flyAnimation = SKAction.group([
            SKAction.repeatForever(flyAction),
            rotateUpAction
            ])
        
        // create the soar animation
        let soarFrames: [SKTexture] = [
            textureAtlas.textureNamed("charles-flying-1")
        ]
        let soarAction = SKAction.animate(with: soarFrames, timePerFrame: 1)
        
        // create rotating down soar animation
        soarAnimation = SKAction.group([
            SKAction.repeatForever(soarAction),
            rotateDownAction
            ])
    }
}
