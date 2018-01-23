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

class GameViewController: UIViewController {
    
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
}
