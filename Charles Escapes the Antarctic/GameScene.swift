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
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        // Set background to sky blue
        backgroundColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1.0)
        
        // create a bee
        let bee = SKSpriteNode()
        
        // set bee size
        bee.size = CGSize(width: 28, height: 24)
        
        // set position
        bee.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.75)
        
        // add bee to scene
        addChild(bee)
        
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
