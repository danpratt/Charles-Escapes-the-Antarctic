//
//  GameScene.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/18/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit
//import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Create world
    let world = SKNode()
    let ground = Ground()
    let encounterManager = EncounterManager()
    let powerUpStar = Star()
    var backgrounds: [Background] = []
    
    // Cache the game start sound
    let gameStartSound = SKAction.playSoundFileNamed("StartGame.aif", waitForCompletion: true)
    
    // Create the player
    let player = Player()
    
    // Player properties for tracking progress
    let hud = HUD()
    let initialPlayerPosition = CGPoint(x: 150, y: 250)
    var playerProgress = CGFloat()
    var nextEncounterSpawnPosition: CGFloat = 150
    
    // Property for collecting coins
    var coinsCollected = 0
    // the amount of coins needed to collect to get a new life
    let coinsForNewLife = 50
    var numberOfNewLivesCollectedMultiplier = 1
    var addingALife = false
    
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
        
        // add encounters as children of the world
        encounterManager.addEncountersToWorld(world: world)
        
        // Create the ground
        let groundPosition = CGPoint(x: -size.width, y: 30)
        
        // Set the ground width to be 3 times the size of the screen
        // Height will be set by child nodes
        let groundSize = CGSize(width: size.width * 3, height: 0)
        ground.spawn(parentNode: world, position: groundPosition, size: groundSize)
        run(gameStartSound)
        // add the player
        player.spawn(parentNode: world, position: initialPlayerPosition)
        // setup a the particles on charles
        guard let dotEmitter = SKEmitterNode(fileNamed: "CharlesPath") else {
            fatalError("Unable to load emitter")
        }
        player.zPosition = 10
        dotEmitter.zPosition = -1
        player.addChild(dotEmitter)
        dotEmitter.targetNode = world
        
//        // start listening to motion events from accelerometer
//        motionManger.startAccelerometerUpdates()
        
        // Setup physics world
        // reduce gravity, since this isn't the real world
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        // enable contact delegate
        physicsWorld.contactDelegate = self
        
        // spawn the star off screen
        powerUpStar.spawn(parentNode: world, position: CGPoint(x: -2000, y: -2000))
        
        // create hud for tracking life and score
        hud.createHUDNodes(screenSize: size)
        addChild(hud)
        // fill hud hearts
        hud.setHealthDisplay(firstSetup: true)
        // make sure hud stays above everything else
        hud.zPosition = 50
        
        // add 4 backgrounds to the array
        for _ in 0..<4 {
            backgrounds.append(Background())
        }
        
        // spawn the new backgrounds
        backgrounds[0].spawn(parentNode: world, imageName: "Background-1", zPosition: -5, movementMultiplier: 0.75)
        backgrounds[1].spawn(parentNode: world, imageName: "Background-2", zPosition: -10, movementMultiplier: 0.5)
        backgrounds[2].spawn(parentNode: world, imageName: "Background-3", zPosition: -15, movementMultiplier: 0.2)
        backgrounds[3].spawn(parentNode: world, imageName: "Background-4", zPosition: -20, movementMultiplier: 0.1)
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
        
        // check to see if we need a new encounter
        if player.position.x > nextEncounterSpawnPosition {
            encounterManager.placeNextEncounter(currentXPosition: nextEncounterSpawnPosition)
            nextEncounterSpawnPosition += 1400
            
            // check to see if we should randomly generate a star
            let starRoll = Int(arc4random_uniform(3))
            if starRoll == 0 {
                // check to make sure star is not already on screen
                if abs(player.position.x - powerUpStar.position.x) > 1200 {
                    let randomYPos = CGFloat(arc4random_uniform(360) + 40)
                    powerUpStar.position = CGPoint(x: nextEncounterSpawnPosition, y: randomYPos)
                    powerUpStar.physicsBody?.angularVelocity = 0
                    powerUpStar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                }
            }
        }
        
        // update background
        for background in backgrounds {
            background.updatePosition(playerProgress: playerProgress)
        }
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
            if let gameSprite = nodeTouched.first as? GameSprite  {
                // run that node's onTap function
                gameSprite.onTap()
            }
            if nodeTouched.first?.name == "restartGame" {
                view?.presentScene(GameScene(size: self.size), transition: .crossFade(withDuration: 0.6))
            } else if nodeTouched.first?.name == "returnToMenu" {
                view?.presentScene(MenuScene(size: self.size), transition: .doorsOpenHorizontal(withDuration: 1))
            }
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
        // saved for future reference, this will not make it into this game
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
    
    // MARK: - Contact Delegate Functions
    func didBegin(_ contact: SKPhysicsContact) {
        // find contact bodies
        let otherBody: SKPhysicsBody
        let penguinMask = PhysicsCategory.penguin.rawValue | PhysicsCategory.damagedPenguin.rawValue
        // figure out which body is the penguin
        otherBody = (contact.bodyA.categoryBitMask & penguinMask) > 0 ? contact.bodyB : contact.bodyA
        // discover contact type
        switch otherBody.categoryBitMask {
        case PhysicsCategory.ground.rawValue:
            player.takeDamage()
            hud.setHealthDisplay(newHealth: player.health)
        case PhysicsCategory.enemy.rawValue:
            player.takeDamage()
            hud.setHealthDisplay(newHealth: player.health)
        case PhysicsCategory.coin.rawValue:
            if player.isDead { return }
            guard let coin = otherBody.node as? Coin else { return }
            coin.collect()
            coinsCollected += coin.value
            hud.setScoreDisplay(newCoinCount: coinsCollected)
            if coinsCollected >= coinsForNewLife * numberOfNewLivesCollectedMultiplier && !addingALife {
                // add to the multiplier no matter what
                numberOfNewLivesCollectedMultiplier += 1
                // don't want lives to go off of the screen, so they are capped out
                if player.health == player.maxHealth { break }
                addingALife = true
                player.gainALife()
                hud.setHealthDisplay(newHealth: player.health, removeHearts: false)
                addingALife = false
            }
        case PhysicsCategory.powerup.rawValue:
            if player.isDead { return }
            player.superStar()
            guard let star = otherBody.node as? Star else { return }
            star.collectStar()
        default:
//            print("Coin has already been picked up, don't want to count it twice!")
            break
        }
    }
    
    // MARK: - Game Over
    func gameOver() {
        updateLeaderboard()
        checkForAchievements()
        hud.showGameOverButtons()
    }
    
    // MARK: - Game Center
    
    // update the leaderboard
    private func updateLeaderboard() {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            // create a new score object
            let coins = GKScore(leaderboardIdentifier: "CTFP_LB")
            // set the score to the value of our coins
            coins.value = Int64(coinsCollected)
            // wrap into an array and report the score
            GKScore.report([coins], withCompletionHandler: { (error) in
                if let error = error {
                    print("There was an error posting to leaderboards: \(String(describing: error))")
                }
            })
        }
    }
    
    // check for achievements
    private func checkForAchievements() {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            // check to see if user has earned over 500 coins
            if coinsCollected >= 500 {
                let achievement = GKAchievement(identifier: "500_coins")
                if !achievement.isCompleted {
                    achievement.showsCompletionBanner = true
                    achievement.percentComplete = 100
                    GKAchievement.report([achievement], withCompletionHandler: { (error) in
                        if let error = error {
                            print("There was an error saving achievement: \(String(describing: error))")
                        }
                    })
                } else {
                    print("Already completed")
                }
            }
            
        // check to see if user has earned over 750 coins
        if coinsCollected >= 750 {
            let achievement = GKAchievement(identifier: "750_coins")
            if !achievement.isCompleted {
                achievement.showsCompletionBanner = true
                achievement.percentComplete = 100
                GKAchievement.report([achievement], withCompletionHandler: { (error) in
                    if let error = error {
                        print("There was an error saving achievement: \(String(describing: error))")
                    }
                })
            } else {
                print("Already completed")
                }
            }
        }
        
        // check to see if user has earned over 1000 coins
        if coinsCollected >= 1000 {
            let achievement = GKAchievement(identifier: "1000_coins")
            if !achievement.isCompleted {
                achievement.showsCompletionBanner = true
                achievement.percentComplete = 100
                GKAchievement.report([achievement], withCompletionHandler: { (error) in
                    if let error = error {
                        print("There was an error saving achievement: \(String(describing: error))")
                    }
                })
            } else {
                print("Already completed")
            }
        }
        
        // check to see if user has earned over 1500 coins
        if coinsCollected >= 1500 {
            let achievement = GKAchievement(identifier: "1500_coins")
            if !achievement.isCompleted {
                achievement.showsCompletionBanner = true
                achievement.percentComplete = 100
                GKAchievement.report([achievement], withCompletionHandler: { (error) in
                    if let error = error {
                        print("There was an error saving achievement: \(String(describing: error))")
                    }
                })
            } else {
                print("Already completed")
            }
        }

        
    }
    
}
