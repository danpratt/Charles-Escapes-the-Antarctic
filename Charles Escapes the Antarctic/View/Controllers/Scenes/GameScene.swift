//
//  GameScene.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/18/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit
import GameplayKit
//import CoreMotion

class GameScene: SKScene {
    
    // Create world
    let world = SKNode()
    let ground = Ground()
    
    // Create the player
    let player = Player()
    
    // Player properties for tracking progress
    let initialPlayerPosition = CGPoint(x: 150, y: 250)
    var playerProgress = CGFloat()
    
//    // CoreMotion Manager
//    let motionManger = CMMotionManager()
    
    // Screen Center
    var screenCenterY = CGFloat()
    
    override func didMove(to view: SKView) {
        // Set background to sky blue
        backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        // add the world
        addChild(world)
        
        // set screen center
        screenCenterY = size.height / 2
        
        // Create the background
        let groundPosition = CGPoint(x: -size.width, y: 30)
        
        // Set the ground width to be 3 times the size of the screen
        // Height will be set by child nodes
        let groundSize = CGSize(width: size.width * 3, height: 0)
        ground.spawn(parentNode: world, position: groundPosition, size: groundSize)
        
        // add the player
        player.spawn(parentNode: world, position: initialPlayerPosition)
        
//        // start listening to motion events from accelerometer
//        motionManger.startAccelerometerUpdates()
        
        // reduce gravity, since this isn't the real world
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
    }
    
    // MARK: - Physics
    override func didSimulatePhysics() {
        var worldYPos: CGFloat = 0
        
        // zoom the world as the penguin flies higher
        if (player.position.y > screenCenterY) {
            let percentOfMaxHeight = (player.position.y - screenCenterY) / (player.maxHeight - screenCenterY)
            let scaleSubtraction = (percentOfMaxHeight > 1 ? 1 : percentOfMaxHeight) * 0.6
            let newScale = 1 - scaleSubtraction
            
            world.yScale = newScale
            world.xScale = newScale
            
            // adjust the world on the y-axis to follow player
            worldYPos = -(player.position.y * world.yScale - (size.height / 2))
        }
        
        let worldXPos = -(player.position.x * world.xScale - (size.width / 3))
        
        // move camera to new position
        world.position = CGPoint(x: worldXPos, y: worldYPos)
        
        // keep track of progress
        playerProgress = player.position.x - initialPlayerPosition.x
        
        // check to see if ground should be jumped forward
        ground.checkForReposition(playerProgress: playerProgress)
    }
    
    // MARK: - Touch Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // no matter what make the player fly
        player.startFlapping()
        
        for touch in touches {
            // get location of the touch
            let location = touch.location(in: self)
            // locate the node at this location
            let nodeTouched = nodes(at: location)
            // check to see if it is a gamekit sprite
            guard let gameSprite = nodeTouched.first as? GameSprite else {
                return
            }
            // run that node's onTap function
            gameSprite.onTap()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    // MARK: - Update
    override func update(_ currentTime: TimeInterval) {
        player.update()
//        // get acceleromter data
//        guard let accelData = motionManger.accelerometerData else {
//            return
//        }
//
//        var forceAmount: CGFloat
//        var movement = CGVector()
//
//        // get current orientation
//        switch UIApplication.shared.statusBarOrientation {
//        case .landscapeLeft:
//            forceAmount = 20000
//        case .landscapeRight:
//            forceAmount = -20000
//        default:
//            forceAmount = 0
//        }
//
//        if accelData.acceleration.y > 0.15 {
//            movement.dx = forceAmount
//        } else if accelData.acceleration.y < -0.15 {
//            movement.dx = -forceAmount
//        }
//
//        player.physicsBody?.applyForce(movement)
    }
    
    
}
