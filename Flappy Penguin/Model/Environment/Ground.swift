//
//  Ground.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/18/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode, GameSprite {
    
    // Ground texture properties
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "ground")
    var groundTexture: SKTexture?
    
    // jump values for jumping ground to follow action
    var jumpWidth = CGFloat()
    var jumpCount = CGFloat(1)
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize) {
        parentNode.addChild(self)
        
        // setup position and size
        self.position = position
        self.size = size
        
        // set anchor point so we can place it just slightly above the bottom of the screen
        anchorPoint = CGPoint(x: 0, y: 1)
        
        // default to ice texture
        if groundTexture == nil {
            groundTexture = textureAtlas.textureNamed("ground")
        }
        
        // repeat the texture accross the screen
        createChildren()
        
        // setup physics body
        let pointTopRight = CGPoint(x: size.width, y: 0)
        physicsBody = SKPhysicsBody(edgeFrom: CGPoint.zero, to: pointTopRight)
        physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
    }
    
    // MARK: - CreateChildren
    private func createChildren() {
        // make sure there is a texture loaded
        guard let texture = groundTexture else {
            fatalError("No ground texture loaded")
        }
        
        var tileCount: CGFloat = 0
        let textureSize = texture.size()
        
        // create a tile size
        let tileSize = CGSize(width: textureSize.width, height: textureSize.height)
        // cover entire ground with textures
        while tileCount * tileSize.width < self.size.width {
            let tileNode = SKSpriteNode(texture: texture)
            tileNode.size = tileSize
            tileNode.position.x = tileCount * tileSize.width
            tileNode.anchorPoint = CGPoint(x: 0, y: 1)
            self.addChild(tileNode)
            tileCount += 1
        }
        
        // find the width for 1/3 the nodes
        jumpWidth = tileSize.width * floor(tileCount / 3)
    }
    
    func checkForReposition(playerProgress: CGFloat) {
        // need to jump the ground ahead every time the player travels jumpWidth
        
        // figure out where jump needs to happen
        let groundJumpPosition = jumpWidth * jumpCount
        
        if playerProgress >= groundJumpPosition {
            // the player is at or passed the jump position, so jump the ground
            // move the ground forward
            self.position.x += jumpWidth
            // add to the jump counter
            jumpCount += 1
        }
    }
    
    func onTap() {
        
    }
    
}
