//
//  MadFly.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/20/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

class MadFly: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "madfly")
    var flyAnimation = SKAction()
    var flightPathAnimation = SKAction()
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 61, height: 29)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        run(flyAnimation)
        run(flightPathAnimation)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
    }
    
    // MARK: - Animations
    
    // Animation for flying
    private func createAnimations() {
        let flyFrames: [SKTexture] = [
            textureAtlas.textureNamed("madfly"),
            textureAtlas.textureNamed("madfly-fly")
        ]
        
        let startPoint = CGPoint.zero
        let leftEndPoint = CGPoint(x: -100, y: 0)
        let rightEndPoint = CGPoint(x: 100, y: 0)
        let leftControlPoint = CGPoint(x: -50, y: 50)
        let rightControlPoint = CGPoint(x: 50, y: -50)
        
        let leftPath = CGMutablePath()
        leftPath.move(to: startPoint)
        leftPath.addQuadCurve(to: leftEndPoint, control: leftControlPoint)
        
        let rightPath = CGMutablePath()
        rightPath.move(to: startPoint)
        rightPath.addQuadCurve(to: rightEndPoint, control: rightControlPoint)
        
        let flyLeftPath = SKAction.follow(leftPath, asOffset: true, orientToPath: false, duration: 2)
        let flyRightPath = SKAction.follow(rightPath, asOffset: true, orientToPath: false, duration: 2)
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.14)
        
        let flyPathSequence = SKAction.sequence([
                flyLeftPath,
                SKAction.scaleX(to: -1, duration: 0.3),
                flyRightPath,
                SKAction.scaleX(to: 1, duration: 0.3)
            ])
        
        let flightGroup = SKAction.group([
                flyPathSequence,
                flyAction
            ])
        
        flyAnimation = SKAction.repeatForever(flyAction)
        flightPathAnimation = SKAction.repeatForever(flightGroup)
    }
    
    func onTap() {
        
    }
    
}
