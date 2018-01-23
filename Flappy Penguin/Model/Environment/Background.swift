//
//  Background.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/23/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    
    // movement multiplier for storing speed
    var movementMultiplier = CGFloat(0)
    
    // for storing jumps
    var jumpAdjustment = CGFloat(0)
    
    // stores background size
    let backgroundSize = CGSize(width: 1000, height: 1000)
    
    func spawn(parentNode: SKNode, imageName: String, zPosition: CGFloat, movementMultiplier: CGFloat) {
        // position from the bottom left
        anchorPoint = CGPoint.zero
        // start backgrounds at top of the ground
        position = CGPoint(x: 0, y: 30)
        // control order of backgrounds with z position
        self.zPosition = zPosition
        // store a movement multiplier
        self.movementMultiplier = movementMultiplier
        
        // add background to the parent node
        parentNode.addChild(self)
        
        // build three child nodes of the texture so that the background is 3000 wide from -1000 to +1000 past
        // 0 position
        for index in -1...1 {
            let newBGNode = SKSpriteNode(imageNamed: imageName)
            newBGNode.size = backgroundSize
            // position from lower left anchor
            newBGNode.anchorPoint = CGPoint.zero
            newBGNode.position = CGPoint(x: CGFloat(index) * backgroundSize.width, y: 0)
            // add child node to the background
            addChild(newBGNode)
        }
    }
    
    // update position so background can jump
    func updatePosition(playerProgress: CGFloat) {
        // calculate position and adjustment after loops and multiplier
        let adjustedPosition = jumpAdjustment + playerProgress * (1 - movementMultiplier)
        // check to see if the background should be moved backward or forward
        if playerProgress - adjustedPosition > backgroundSize.width {
            jumpAdjustment += backgroundSize.width
        }
        
        // adjust this background forward as the world moves back so the background appears slower
        position.x = adjustedPosition
    }
}
