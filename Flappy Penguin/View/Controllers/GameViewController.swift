//
//  GameViewController.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/18/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import GameKit

class GameViewController: UIViewController {
    
    // var for audioplayer
    var musicPlayer = AVAudioPlayer()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Create Menu Scene
        let menuScene = MenuScene()
        let skView = view as! SKView
        // ignore drawing order of child nodes to increase performance
        skView.ignoresSiblingOrder = true
        // size scene to fit device
        menuScene.size = view.bounds.size
        // show the menu
        skView.presentScene(menuScene)
        
        // start music
        let musicURL = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "m4a")
        if let url = musicURL {
            musicPlayer = try! AVAudioPlayer(contentsOf: url)
            musicPlayer.numberOfLoops = -1
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        }
        
        // setup game center
        authenticateLocalPlayer(scene: menuScene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }

    // we don't want to show a status bar in a game
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Game Center
    private func authenticateLocalPlayer(scene: MenuScene) {
        // create a new game center local instance
        let localPlayer = GKLocalPlayer.localPlayer()
        // check authentication status
        localPlayer.authenticateHandler = {
            (viewController: UIViewController!, error: Error!) -> Void in
            if viewController != nil {
                // they are logged in so show login
                self.present(viewController, animated: true, completion: nil)
            } else if localPlayer.isAuthenticated {
                // they authenticated
            }
        }
    }
}
