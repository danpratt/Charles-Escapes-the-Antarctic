//
//  Player.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/18/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

enum PenguinAnimation: String {
    typealias RawValue = String
    case Soar = "soarAnimation", Fly = "flyAnimation", Star = "superStar"
}

class Player: SKSpriteNode, GameSprite {
    
    // Texture Atlas
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "charles")
    
    // Animations
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    var damageAnimation = SKAction()
    var dieAnimation = SKAction()
    
    // Sounds
    let powerUpSound = SKAction.playSoundFileNamed("Powerup.aif", waitForCompletion: false)
    let hurtSound = SKAction.playSoundFileNamed("Hurt.aif", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("GameOver.wav", waitForCompletion: true)
    
    // physics control logic
    var flapping = false
    let maxFlappingForce: CGFloat = 57000
    let maxHeight: CGFloat = 1000
    let maxVelocity: CGFloat = 300
    var forwardVelocity: CGFloat = 200
    
    // player health
    var health: Int = 3
    let maxHealth = 9
    var isGodModeOn = false
    var isDamaged = false
    var isDead = false
    
    // MARK: - Spawn
    
    func spawn(parentNode: SKNode, position: CGPoint, size: CGSize = CGSize(width: 64, height: 64)) {
        parentNode.addChild(self)
        createAnimations()
        self.size = size
        self.position = position
        
        run(soarAnimation, withKey: PenguinAnimation.Soar.rawValue)
        
        // setup physics body
        // use flying 3 image, because wings are tucked in
        let bodyTexture = textureAtlas.textureNamed("charles-flying-3")
        physicsBody = SKPhysicsBody(texture: bodyTexture, size: size)
        // loses momentum quickly
        physicsBody?.linearDamping = 0.9
        // set mass to be close to a real penguin
        physicsBody?.mass = 30
        // prevent rotating
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
        physicsBody?.contactTestBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.ground.rawValue | PhysicsCategory.powerup.rawValue | PhysicsCategory.coin.rawValue
        
        // grant a momentary reprieve from gravity
        physicsBody?.affectedByGravity = false
        physicsBody?.velocity.dy = 50
        // create action to start gravity after short delay
        let startGravitySequence = SKAction.sequence([
                SKAction.wait(forDuration: 0.6),
                SKAction.run {
                    self.physicsBody?.affectedByGravity = true
            }
            ])
        run(startGravitySequence)
    }
    
    // MARK: - Update Function
    func update() {
        // add force to push charles higher
        if flapping {
            var forceToApply = maxFlappingForce
            // apply less force if charles is higher than 600
            if position.y > 600 {
                let percentageOfMaxHeight = position.y / maxHeight
                let flappingForceSubtraction = percentageOfMaxHeight * maxFlappingForce
                forceToApply -= flappingForceSubtraction
            }
            // apply the force
            physicsBody?.applyForce(CGVector(dx: 0, dy: forceToApply))
        }
        
        // prevent charles from getting over max height
        guard let velocityDY = physicsBody?.velocity.dy else {
            print("Couldn't get velocity")
            return
        }
        
        physicsBody?.velocity.dy = velocityDY > maxVelocity ? maxVelocity : velocityDY
        physicsBody?.velocity.dx = forwardVelocity
    }
    
    // MARK: - OnTap Function
    
    func onTap() {
        
    }
    
    // MARK: - Animations
    
    // MARK: - Create Animations
    private func createAnimations() {
        // rotate up animation
        let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
        rotateUpAction.timingMode = .easeOut
        
        // rotate down animation
        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.8)
        rotateDownAction.timingMode = .easeOut
        
        // create flying animation
        let flyFrames: [SKTexture] = [
            textureAtlas.textureNamed("charles-flying-1"),
            textureAtlas.textureNamed("charles-flying-2"),
            textureAtlas.textureNamed("charles-flying-3"),
            textureAtlas.textureNamed("charles-flying-4"),
            textureAtlas.textureNamed("charles-flying-3"),
            textureAtlas.textureNamed("charles-flying-2")
        ]
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.03)
        
        // create rotating up flying animation
        flyAnimation = SKAction.group([
            SKAction.repeatForever(flyAction),
            rotateUpAction
            ])
        
        // create the soar animation
        let soarFrames: [SKTexture] = [
            textureAtlas.textureNamed("charles-flying-1")
        ]
        let soarAction = SKAction.animate(with: soarFrames, timePerFrame: 1)
        
        // create rotating down soar animation
        soarAnimation = SKAction.group([
            SKAction.repeatForever(soarAction),
            rotateDownAction
            ])
        
        // --- create taking damage animation ---
        let damageStart = SKAction.run {
            // allow penguin to pass through enemies
            self.physicsBody?.categoryBitMask = PhysicsCategory.damagedPenguin.rawValue
            // remove enemies from collision test
            self.physicsBody?.collisionBitMask = ~PhysicsCategory.enemy.rawValue
            // create a pulse that is slow in the beginning and fast in the end
        }
        let slowFade = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.3, duration: 0.35),
                SKAction.fadeAlpha(to: 0.7, duration: 0.35)
            ])
        let fastFade = SKAction.sequence([
                SKAction.fadeAlpha(to: 0.3, duration: 0.2),
                SKAction.fadeAlpha(to: 0.7, duration: 0.2)
            ])
        let fadeOutAndIn = SKAction.sequence([
                SKAction.repeat(slowFade, count: 2),
                SKAction.repeat(fastFade, count: 5),
                SKAction.fadeAlpha(to: 1, duration: 0.15)
            ])
        
        let damageEnd = SKAction.run {
            // change back to normal penguin
            self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
            // collide with everything again
            self.physicsBody?.collisionBitMask = 0xFFFFFFFF
            // turn off the newly damaged flag
            self.isDamaged = false
        }
        
        // set the whole sequence to the damage animation property
        damageAnimation = SKAction.sequence([
                damageStart,
                fadeOutAndIn,
                damageEnd
            ])
        
        // -- Create death animation ---
        let startDie = SKAction.run {
            // Switch to death image
            self.texture = self.textureAtlas.textureNamed("charles-dead")
            // Freeze charles in space
            self.physicsBody?.affectedByGravity = false
            // stop any movement
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            // make charles pass through everything but the ground
            self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
        }
        
        let endDie = SKAction.run {
            // turn gravity back on
            self.physicsBody?.affectedByGravity = true
        }
        
        dieAnimation = SKAction.sequence([
                startDie,
                // scale charles to be bigger
                SKAction.scale(to: 1.3, duration: 0.5),
                // wait for it...
                SKAction.wait(forDuration: 0.5),
                // rotate charles onto his back
                SKAction.rotate(toAngle: 3, duration: 0.2),
                SKAction.wait(forDuration: 0.5),
                endDie,
                SKAction.wait(forDuration: 1),
                gameOverSound,
                SKAction.run({
                    // show gameover buttons
                    guard let gameScene = self.parent?.parent as? GameScene else {
                        fatalError("Player Dies: Somehow the parent's parent is not the GameScene, check logic")
                    }
                    gameScene.gameOver()
                })
            ])
    }
    
    // MARK: - Start Flapping
    func startFlapping() {
        if self.health <= 0 { return }
        removeAction(forKey: PenguinAnimation.Soar.rawValue)
        run(flyAnimation, withKey: PenguinAnimation.Fly.rawValue)
        flapping = true
    }
    
    // MARK: - Stop Flapping
    func stopFlapping() {
        if self.health <= 0 { return }
        removeAction(forKey: PenguinAnimation.Fly.rawValue)
        run(soarAnimation, withKey: PenguinAnimation.Soar.rawValue)
        flapping = false
    }
    
    // MARK: - Player Dies
    private func die() {
        isDead = true
        // make sure player is fully visible
        alpha = 1
        // remove all animations
        removeAllActions()
        // stop any further movement
        flapping = false
        forwardVelocity = 0
        // run die animation
        run(dieAnimation)
    }
    
    // MARK: - Taking Damage
    func takeDamage() {
        // if in god mode or damaged, just return
        if isGodModeOn || isDamaged { return }
        
        // set damaged state to true
        isDamaged = true
        
        // remove 1 health
        health -= 1
        print("Player has: \(String(describing: health))")
        // check to see if player died
        if health <= 0 {
            die()
        } else {
            run(damageAnimation)
        }
        
        // play hurt sound
        run(hurtSound)
    }
    
    // MARK: - Gain a life
    func gainALife() {
        health += 1
        print("Player lives: \(String(describing: health))")
    }
    
    // MARK: - Star Collection
    func superStar() {
        // remove any existing star powerup animation (if existing)
        removeAction(forKey: PenguinAnimation.Star.rawValue)
        // Speed up
        forwardVelocity = 400
        // turn on god mode
        isGodModeOn = true
        // set star power sequence to play for 8 seconds
        let superStar = SKAction.sequence([
                SKAction.scale(to: 0.7, duration: 0.1),
                SKAction.scale(to: 1.1, duration: 0.1),
                SKAction.scale(to: 0.6, duration: 0.1),
                SKAction.scale(to: 1.5, duration: 0.3),
                SKAction.wait(forDuration: 8),
                SKAction.scale(to: 1, duration: 1),
                SKAction.run({
                    self.forwardVelocity = 200
                    self.isGodModeOn = false
                })
            ])
        run(superStar, withKey: PenguinAnimation.Star.rawValue)
        run(powerUpSound)
    }
}
