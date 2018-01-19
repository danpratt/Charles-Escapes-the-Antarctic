//
//  GameScene.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/18/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Create world
    let world = SKNode()
    let ground = Ground()
    
    // Create the player
    let player = Player()
    
    override func didMove(to view: SKView) {
        // Set background to sky blue
        backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        // add the world
        addChild(world)
        
        // add bees from the new class
        let r2b2 = Bee()
        let r2b3 = Bee()
        let r2b4 = Bee()
        
        // spawn the bees
        r2b2.spawn(parentNode: world, position: CGPoint(x: 325, y: 325))
        r2b3.spawn(parentNode: world, position: CGPoint(x: 200, y: 325))
        r2b4.spawn(parentNode: world, position: CGPoint(x: 50, y: 200))
        
        // start moving r2b2 so it crashes into r2b3
        r2b2.physicsBody?.mass = 0.2
        r2b2.physicsBody?.applyImpulse(CGVector(dx: -15, dy: 0))
        
        // Create the background
        let groundPosition = CGPoint(x: -size.width, y: 100)
        
        // Set the ground width to be 3 times the size of the screen
        // Height will be set by child nodes
        let groundSize = CGSize(width: size.width * 3, height: 0)
        ground.spawn(parentNode: world, position: groundPosition, size: groundSize)
        
        // add the player
        player.spawn(parentNode: world, position: CGPoint(x: 150, y: 250))
    }
    
    // MARK: - Physics
    override func didSimulatePhysics() {
        // find the correct position to keep sprite centered
        let worldXPos = -(player.position.x * world.xScale - (size.width / 2))
        let worldYPos = -(player.position.y * world.yScale - (size.height / 2))

        // move the world so the bee stays centered
        world.position = CGPoint(x: worldXPos, y: worldYPos)
    }
    
    
}
