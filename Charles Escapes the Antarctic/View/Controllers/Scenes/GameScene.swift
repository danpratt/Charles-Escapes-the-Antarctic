//
//  GameScene.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/18/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    // Create world
    let world = SKNode()
    let ground = Ground()
    
    // Create the player
    let player = Player()
    
    // CoreMotion Manager
    let motionManger = CMMotionManager()
    
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
        
        // Create the background
        let groundPosition = CGPoint(x: -size.width, y: 30)
        
        // Set the ground width to be 3 times the size of the screen
        // Height will be set by child nodes
        let groundSize = CGSize(width: size.width * 3, height: 0)
        ground.spawn(parentNode: world, position: groundPosition, size: groundSize)
        
        // add the player
        player.spawn(parentNode: world, position: CGPoint(x: 150, y: 250))
        
        // start listening to motion events from accelerometer
        motionManger.startAccelerometerUpdates()
    }
    
    // MARK: - Physics
    override func didSimulatePhysics() {
        // find the correct position to keep sprite centered
        let worldXPos = -(player.position.x * world.xScale - (size.width / 2))
        let worldYPos = -(player.position.y * world.yScale - (size.height / 2))

        // move the world so the bee stays centered
        world.position = CGPoint(x: worldXPos, y: worldYPos)
    }
    
    // MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        player.update()
        // get acceleromter data
        guard let accelData = motionManger.accelerometerData else {
            print("Unable to get acceleromter data")
            return
        }
        
        var forceAmount: CGFloat
        var movement = CGVector()
        
        // get current orientation
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft:
            forceAmount = 20000
        case .landscapeRight:
            forceAmount = -20000
        default:
            forceAmount = 0
        }
        
        if accelData.acceleration.y > 0.15 {
            movement.dx = forceAmount
        } else if accelData.acceleration.y < -0.15 {
            movement.dx = -forceAmount
        }
        
        player.physicsBody?.applyForce(movement)
    }
    
    
}
