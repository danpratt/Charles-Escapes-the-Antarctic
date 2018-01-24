//
//  MenuScene.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/23/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit
import GameKit

class MenuScene: SKScene, GKGameCenterControllerDelegate {

    // get texture
    let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "hud")
    // instantiate a sprite node for the start button
    let startButton = SKSpriteNode()
    var startButtonPressedAction = SKAction()
    
    // sky blue color
    let skyBlueColor = UIColor(red: 0.4, green: 0.6, blue: 0.95, alpha: 1)
    
    // MARK: - Did Move to View
    
    override func didMove(to view: SKView) {
        // position nodes from scene center
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // set sky blue background color
        backgroundColor = skyBlueColor
        // add background image
        let backgroundImage = SKSpriteNode(imageNamed: "background-menu")
        let backgroundImageWidth = UIScreen.main.bounds.width
        let backgroundImageHeight = UIScreen.main.bounds.height
        let backgroundImageSize = CGSize(width: backgroundImageWidth, height: backgroundImageHeight)
        backgroundImage.size = backgroundImageSize
        backgroundImage.zPosition = -20
        addChild(backgroundImage)
        
        // setup logo
        
        // first line of text
        let logoTextTop = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        logoTextTop.text = "Charles"
        logoTextTop.position = CGPoint(x: 0, y: 100)
        logoTextTop.fontSize = 60
        logoTextTop.zPosition = 10
        addChild(logoTextTop)
        
        // second line of text below
        let logoTextBottom = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        logoTextBottom.text = "The Flappy Penguin"
        logoTextBottom.position = CGPoint(x: 0, y: 50)
        logoTextBottom.fontSize = 40
        logoTextBottom.zPosition = 10
        addChild(logoTextBottom)
        
        // add start button
        startButton.texture = textureAtlas.textureNamed("button")
        startButton.size = CGSize(width: 295, height: 76)
        // name for touch detection
        startButton.name = "StartButton"
        startButton.position = CGPoint(x: 0, y: -15)
        startButton.zPosition = 10
        addChild(startButton)
        
        // add text to the button
        let startButtonText = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        startButtonText.text = "START GAME"
        startButtonText.verticalAlignmentMode = .center
        startButtonText.position = CGPoint(x: 0, y: -13)
        startButtonText.fontSize = 40
        // add name for touch detection
        startButtonText.name = "StartButtonText"
        startButtonText.zPosition = 15
        addChild(startButtonText)
        
        // pulse the start button
        let pulseAction = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.7, duration: 0.9),
                SKAction.fadeAlpha(to: 1, duration: 0.9)
            ])
        startButton.run(SKAction.repeatForever(pulseAction))
        startButtonText.run(SKAction.repeatForever(pulseAction))
        
        // setup start button tapped sequence
        startButtonPressedAction = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.5, duration: 0.1),
                SKAction.fadeAlpha(to: 0.8, duration: 0.1),
                SKAction.fadeAlpha(to: 0.6, duration: 0.07),
                SKAction.fadeAlpha(to: 0.9, duration: 0.07),
                SKAction.fadeAlpha(to: 0.7, duration: 0.07),
                SKAction.fadeAlpha(to: 1, duration: 0.1),
                SKAction.run({
                    self.view?.presentScene(GameScene(size: self.size))
                })
            ])
        
        // Game center
        print("Loaded")
        if GKLocalPlayer.localPlayer().isAuthenticated {
            print("Authenticated")
            createLeaderBoardButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodesTouched = nodes(at: location)
            
            // see if any of the nodes here are the correct node
            for node in nodesTouched {
                if node.name?.range(of: "StartButton") != nil {
                    startButton.run(startButtonPressedAction)
                    break
                } else if node.name == "LeaderboardButton" {
                    showLeaderboard()
                }
            }
            
        }
    }
    
    // MARK: - Game Center
    
    // required delegate function
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    // create leaderboard button
    func createLeaderBoardButton() {
        // add the background
        let background = SKSpriteNode(color: skyBlueColor, size: CGSize(width: 145, height: 28))
        // add some text
        let leaderBoardText = SKLabelNode(fontNamed: "ChalkboardSE-Regular")
        leaderBoardText.text = "Leaderboard"
        leaderBoardText.name = "LeaderboardButton"
        leaderBoardText.verticalAlignmentMode = .center
        background.position = CGPoint(x: 0, y: -98)
        leaderBoardText.fontSize = 20
        background.addChild(leaderBoardText)
        background.alpha = 0.9
        addChild(background)
    }
    
    // show the leaderboard
    private func showLeaderboard() {
        // create the view controller
        let gameCenter = GKGameCenterViewController()
        // set this scene as delegate
        gameCenter.gameCenterDelegate = self
        // show the leaderboards
        gameCenter.viewState = .default
        // find the current view controller
        if let gameViewController = self.view?.window?.rootViewController {
            gameViewController.show(gameCenter, sender: self)
            gameViewController.navigationController?.pushViewController(gameCenter, animated: true)
        }
        
    }

}
