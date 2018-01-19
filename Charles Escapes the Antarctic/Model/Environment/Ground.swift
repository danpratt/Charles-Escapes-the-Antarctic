//
//  Ground.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/18/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "ground")
    var groundTexture: SKTexture?
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize) {
        parentNode.addChild(self)
        
        // setup position and size
        self.position = position
        self.size = size
        
        // set anchor point so we can place it just slightly above the bottom of the screen
        self.anchorPoint = CGPoint(x: 0, y: 1)
        
        // default to ice texture
        if groundTexture == nil {
            groundTexture = textureAtlas.textureNamed("ground")
        }
        
        // repeat the texture accross the screen
        createChildren()
    }
    
    // OnTap is only here to conform to protocol
    func onTap() {
        
    }
    
    // MARK: - CreateChildren
    private func createChildren() {
        // make sure there is a texture loaded
        guard let texture = groundTexture else {
            fatalError("No ground texture loaded")
        }
        
        var tileCount: CGFloat = 0
        let textureSize = texture.size()
        
        // improve image quality by sizing at half the texture size
        let tileSize = CGSize(width: textureSize.width / 2, height: textureSize.height / 2)
        
        // cover entire ground with textures
        while tileCount * tileSize.width < self.size.width {
            let tileNode = SKSpriteNode(texture: texture)
            tileNode.size = tileSize
            tileNode.position.x = tileCount * tileSize.width
            tileNode.anchorPoint = CGPoint(x: 0, y: 1)
            self.addChild(tileNode)
            tileCount += 1
        }
    }
    
    
}
