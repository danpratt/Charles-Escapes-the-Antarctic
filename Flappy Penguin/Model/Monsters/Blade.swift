//
//  Blade.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/20/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

class Blade: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "blade")
    var spinAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 185, height: 92)) {
        parentNode.addChild(self)
        self.size = size
        self.position = position
        physicsBody = SKPhysicsBody(texture: textureAtlas.textureNamed("blade"), size: size)
        physicsBody?.affectedByGravity = false
        // not dynamic because it should never move
        physicsBody?.isDynamic = false
        createAnimations()
        run(spinAnimation)
    }
    
    // MARK: - Animations
    
    // create spinning animation
    private func createAnimations() {
        let spinFrames: [SKTexture] = [
            textureAtlas.textureNamed("blade"),
            textureAtlas.textureNamed("blade-2")
        ]
        
        let spinAction = SKAction.animate(with: spinFrames, timePerFrame: 0.07)
        
        spinAnimation = SKAction.repeatForever(spinAction)
    }
    
    func onTap() {
        
    }
}
