//
//  Coin.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/20/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

class Coin: SKSpriteNode, GameSprite {
    
    // coin animations
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "goods")
    var glowAnimation = SKAction()
    
    // coin sound played when player collects a coin
    let coinSound = SKAction.playSoundFileNamed("Coin.aif", waitForCompletion: false)
    
    // coin value, storing default value for bronze coin
    var value: Int = 1
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 26, height: 26)) {
        parentNode.addChild(self)
        self.size = size
        self.position = position
        
        // setup phyiscs
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        physicsBody?.collisionBitMask = 0
        
        // set default texture to bronze coin
        texture = textureAtlas.textureNamed("coin-bronze")
        createAnimations()
        run(glowAnimation)
    }
    
    // MARK: - Change to gold star
    func turnToGold() {
        texture = textureAtlas.textureNamed("coin-gold")
        value = 5
    }
    
    // MARK: - Animations
    
    // create an animation to fade in and out
    private func createAnimations() {
        let fadeOutAction = SKAction.group([
                SKAction.fadeAlpha(to: 0.8, duration: 1),
                SKAction.scale(to: 0.8, duration: 1)
            ])
        
        let fadeInAction = SKAction.group([
                SKAction.fadeAlpha(to: 1.5, duration: 1),
                SKAction.scale(to: 1, duration: 1)
            ])
        
        let glowSequence = SKAction.sequence([
                fadeOutAction,
                fadeInAction
            ])
        
        glowAnimation = SKAction.repeatForever(glowSequence)
    }
    
    func onTap() {
        
    }
    
    func collect() {
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
            self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        }
        
        // combine into sequence
        let collectSequence = SKAction.sequence([
                collectAnimation,
                resetAfterCollected
            ])
        // run collection
        run(collectSequence)
        // play sounds
        run(coinSound)
    }
}
