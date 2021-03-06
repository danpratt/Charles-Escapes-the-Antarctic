//
//  HUD.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/23/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    // load texture atlas
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "hud")
    // keep track of hearts
    var heartNodes: [SKSpriteNode] = []
    // Label Node to display score
    let scoreText = SKLabelNode(text: "000000")
    
    // setup restart nodes
    let restartButton = SKSpriteNode()
    let menuButton = SKSpriteNode()
    
    // store screen size
    var screenSize: CGSize!
    
    // store animations
    // fade out lost hearts
    let removeHeartsAction = SKAction.group([
            SKAction.fadeAlpha(to: 0.2, duration: 0.3),
            SKAction.scale(to: 0.7, duration: 0.3)
        ])
    // pop in new hearts
    let addHeartsAction = SKAction.sequence([
            SKAction.group([
                SKAction.fadeAlpha(to: 0.7, duration: 0.5),
                SKAction.scale(to: 1.5, duration: 0.5)
                ]),
            SKAction.group([
                SKAction.scale(to: 1, duration: 0.5),
                SKAction.fadeIn(withDuration: 0.5)
                ])
        ])
    
    func createHUDNodes(screenSize: CGSize) {
        // set screen size
        self.screenSize = screenSize
        // --- Create the coin cointer --- //
        // create a bronze coin icon
        let coinTextureAtlas = SKTextureAtlas(named: "goods")
        let coinIcon = SKSpriteNode(texture: coinTextureAtlas.textureNamed("coin-bronze"))
        // size and position the coin icon
        let coinYPos = screenSize.height - 23
        coinIcon.size = CGSize(width: 26, height: 26)
        coinIcon.position = CGPoint(x: 23, y: coinYPos)
        // setup score text label
        scoreText.fontName = "AvenirNext-HeavyItalic"
        scoreText.position = CGPoint(x: 41, y: coinYPos)
        // align text
        scoreText.horizontalAlignmentMode = .left
        scoreText.verticalAlignmentMode = .center
        // add the icon and text
        addChild(coinIcon)
        addChild(scoreText)
        
        // --- Create life bar --- //
        addHeartsToLifebar(hearts: 3)
        
        // --- Create restart nodes -- //
        restartButton.texture = textureAtlas.textureNamed("button-restart")
        menuButton.texture = textureAtlas.textureNamed("button-menu")
        // add names to nodes so they can be tapped on
        restartButton.name = "restartGame"
        menuButton.name = "returnToMenu"
        // position the button nodes
        let centerOfScreen = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        restartButton.position = centerOfScreen
        menuButton.position = CGPoint(x: centerOfScreen.x - 140, y: centerOfScreen.y)
        // set button sizes
        restartButton.size = CGSize(width: 140, height: 140)
        menuButton.size = CGSize(width: 70, height: 70)
    }
    
    // MARK: - Update HUD
    
    // update score
    func setScoreDisplay(newCoinCount: Int) {
        let scoreFormatter = NumberFormatter()
        scoreFormatter.minimumIntegerDigits = 6
        guard let coinString = scoreFormatter.string(from: newCoinCount as NSNumber) else {
            fatalError("Score Formatter: Unable to get string version of input, check logic")
        }
        
        // update the score
        scoreText.text = coinString
    }
    
    // update life
    func setHealthDisplay(newHealth: Int = 3, removeHearts: Bool = true, firstSetup: Bool = false) {
        if heartNodes.count < newHealth { addHeartsToLifebar() }
        for (index, heart) in heartNodes.enumerated() {
            if firstSetup { heart.run(addHeartsAction) }
            else {
                let newHealthIndex = newHealth - 1
                if index < newHealthIndex - 1 {
                    heart.alpha = 1.0
                } else if removeHearts && index == newHealth {
                    heart.run(removeHeartsAction)
                } else if !removeHearts && index == newHealthIndex {
                    heart.run(addHeartsAction)
                }
            }
        }
    }
    
    // show game over buttons
    func showGameOverButtons() {
        // let buttons fade in so start alpha at 0
        restartButton.alpha = 0
        menuButton.alpha = 0
        // add buttons
        addChild(restartButton)
        addChild(menuButton)
        // fade in
        let fadeInAnimation = SKAction.fadeIn(withDuration: 0.4)
        restartButton.run(fadeInAnimation)
        menuButton.run(fadeInAnimation)
    }
    
    func addHeartsToLifebar(hearts: Int = 1) {
        let lowerBound = heartNodes.count
        let upperBound = lowerBound + hearts
        // --- Create life bar --- //
        for index in lowerBound..<upperBound {
            let newHeartNode = SKSpriteNode(texture: textureAtlas.textureNamed("heart-full"))
            newHeartNode.size = CGSize(width: 46, height: 40)
            // setup x and y positions
            let heartXPosition = CGFloat(index * 60 + 33)
            let heartYPosition = CGFloat(screenSize.height - 66)
            newHeartNode.position = CGPoint(x: heartXPosition, y: heartYPosition)
            newHeartNode.alpha = 0
            
            // add heart to array so they can be removed
            heartNodes.append(newHeartNode)
            // add to the hud
            addChild(newHeartNode)
        }
    }
    
}
