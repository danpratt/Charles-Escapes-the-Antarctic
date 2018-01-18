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
        
        // create a constant sprite node
        let mySprite = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        
        // set position of mySprite
        let position = CGPoint(x: view.bounds.width * 0.75, y: view.bounds.height * 0.666)
        mySprite.position = position
        
        // add sprite to node tree
        addChild(mySprite)
        
        // setup action for sprite
        let demoAction = SKAction.move(to: CGPoint(x: view.bounds.width * 0.25 / 2, y: view.bounds.height * 0.666), duration: 5)
        let demoResizeAction = SKAction.scale(to: 2, duration: 5)
        let demoRotateAction = SKAction.rotate(byAngle: 4 * CGFloat.pi, duration: 5)
        let actionGroup = SKAction.group([demoResizeAction, demoAction, demoRotateAction])
        mySprite.run(SKAction.sequence([actionGroup]))
        
    }
}
