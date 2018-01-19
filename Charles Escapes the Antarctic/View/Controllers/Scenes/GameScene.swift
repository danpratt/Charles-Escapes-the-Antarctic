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
    
    // Create a bee
    let bee = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        // Set background to sky blue
        backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        // add the world
        addChild(world)
        // call the new bee function
        addTheFlyingBee()
        
        // add bees from the new class
        let r2b2 = Bee()
        let r2b3 = Bee()
        let r2b4 = Bee()
        
        // spawn the bees
        r2b2.spawn(parentNode: world, position: CGPoint(x: 325, y: 325))
        r2b3.spawn(parentNode: world, position: CGPoint(x: 200, y: 325))
        r2b4.spawn(parentNode: world, position: CGPoint(x: 50, y: 200))
        
        // Create the background
        let groundPosition = CGPoint(x: -size.width, y: 100)
        
        // Set the ground width to be 3 times the size of the screen
        // Height will be set by child nodes
        let groundSize = CGSize(width: size.width * 3, height: 0)
        
        ground.spawn(parentNode: world, position: groundPosition, size: groundSize)
    }
    
    // MARK: - Physics
    override func didSimulatePhysics() {
        // find the correct position to keep sprite centered
        let worldXPos = -(bee.position.x * world.xScale - (size.width / 2))
        let worldYPos = -(bee.position.y * world.yScale - (size.height / 2))

        // move the world so the bee stays centered
        world.position = CGPoint(x: worldXPos, y: worldYPos)
    }
    
    // MARK: - Bee Node and Animations Setup
    
    private func addTheFlyingBee() {
        // set position
        bee.position = CGPoint(x: 250, y: 250)
        // set bee size
        bee.size = CGSize(width: 28, height: 24)
        
        // add bee to the world
        world.addChild(bee)
        
        // setup bee atlas for animation
        let beeAtlas = SKTextureAtlas(named: "bee")
        let beeFrames: [SKTexture] = [
            beeAtlas.textureNamed("bee"),
            beeAtlas.textureNamed("bee-fly")
        ]
        
        // frames to repeat
        let flyAction = SKAction.animate(with: beeFrames, timePerFrame: 0.14)
        // animate forever
        let beeFlyAction = SKAction.repeatForever(flyAction)
        bee.run(beeFlyAction)
        
        // move the bee back and forth
        
        // setup paths
        let pathLeft = SKAction.moveBy(x: -200, y: -10, duration: 2)
        let pathRight = SKAction.moveBy(x: 200, y: 10, duration: 2)
        
        // flip texture around when changing direction
        let flipTextureNegative = SKAction.scaleX(to: -1, duration: 0.14)
        let flipTexturePositive = SKAction.scaleX(to: 1, duration: 0.14)
        
        // combine actions into flight path
        let flightOfTheBumbleBee = SKAction.sequence([pathLeft,
                                                      flipTextureNegative,
                                                      pathRight, flipTexturePositive
            ])
        let neverEndingFlight = SKAction.repeatForever(flightOfTheBumbleBee)
        
        // make the bee fly
        bee.run(neverEndingFlight)
    }
    
    
}
