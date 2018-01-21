//
//  EncounterManager.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/20/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

struct EncounterKeys {
    
    static let InitialPosition = "initialPosition"
}

class EncounterManager {
    // store encounter scene names
    let encounterNames: [String] = [
        "EncounterBats",
        "EncounterBees",
        "EncounterCoins"
    ]
    
    // Create array for nodes
    var encounters: [SKNode] = []
    
    // variables to keep track of encounters
    var currentEncounterIndex: Int?
    var previousEncounterIndex: Int?
    
    init() {
        // Loop through each encounter scene
        for encounterFileName in encounterNames {
            let encounter = SKNode()
            // Load the scene file into instance
            guard let encounterScene = SKScene(fileNamed: encounterFileName) else {
                fatalError("Unable to load scene, check filename")
            }
            
            for node in encounterScene.children {
                // spawn nodes
                guard let nodeName = node.name else {
                    fatalError("Error getting name from node, please check that all nodes have names")
                }
                switch nodeName {
                case "Bat":
                    let bat = Bat()
                    bat.spawn(parentNode: encounter, position: node.position)
                case "Bee":
                    let bee = Bee()
                    bee.spawn(parentNode: encounter, position: node.position)
                case "Blade":
                    let blade = Blade()
                    blade.spawn(parentNode: encounter, position: node.position)
                case "Ghost":
                    let ghost = Ghost()
                    ghost.spawn(parentNode: encounter, position: node.position)
                case "MadFly":
                    let madFly = MadFly()
                    madFly.spawn(parentNode: encounter, position: node.position)
                case "GoldCoin":
                    let goldCoin = Coin()
                    goldCoin.spawn(parentNode: encounter, position: node.position)
                    goldCoin.turnToGold()
                case "BronzeCoin":
                    let bronzeCoin = Coin()
                    bronzeCoin.spawn(parentNode: encounter, position: node.position)
                default:
                    fatalError("Unable to spawn \(nodeName).  Please check spelling.")
                }
            }
            
            // add populated encounter to the array
            encounters.append(encounter)
            // save initial positions for sprites
            saveSpritePositions(node: encounter)
        }
    }
    
    // MARK: - Encounter Placement Functions
    
    // Add encounters to provided world
    func addEncountersToWorld(world: SKNode) {
        for (index, encounter) in encounters.enumerated() {
            // spawn encounters with increasing hight so they don't collide
            encounter.position = CGPoint(x: -2000, y: index * 1000)
            world.addChild(encounter)
        }
    }
    
    // logic for placing next encounter called from gamescene
    func placeNextEncounter(currentXPosition: CGFloat) {
        // count the encounters
        let encounterCount = UInt32(encounters.count)
        // make sure there are at least 3 encounters otherwise exit function
        if encounterCount < 3 { return }
        // make sure that current encounter is not made to be the next encounter
        var nextEncounterIndex: Int?
        var isNew: Bool = false
        
        while !isNew {
            nextEncounterIndex = Int(arc4random_uniform(encounterCount))
            isNew = currentEncounterIndex != nextEncounterIndex && previousEncounterIndex != nextEncounterIndex ? true : false
        }

        // update values
        previousEncounterIndex = currentEncounterIndex
        currentEncounterIndex = nextEncounterIndex
        
        // setup new encounter ahead of player
        guard let currentIndex = currentEncounterIndex else {
            fatalError("Current index is nil, check logic")
        }
        
        let encounter = encounters[currentIndex]
        encounter.position = CGPoint(x: currentXPosition + 1000, y: 0)
        resetSpritePositions(node: encounter)
    }
    
    // store children initial position
    private func saveSpritePositions(node: SKNode) {
        for sprite in node.children {
            let initialPositionValue = NSValue(cgPoint: sprite.position)
            sprite.userData = [
                EncounterKeys.InitialPosition: initialPositionValue
            ]
            // save sprite positions for children of current node
            saveSpritePositions(node: sprite)
        }
    }
    
    // reset to original positions
    private func resetSpritePositions(node: SKNode) {
        for sprite in node.children {
            // remove any velocity
            sprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            sprite.physicsBody?.angularVelocity = 0
            // reset any rotation
            sprite.zRotation = 0
            
            // reset back to original position
            guard let initialPositionValue = sprite.userData?.value(forKey: EncounterKeys.InitialPosition) as? NSValue else {
                fatalError("No initial position value exists")
            }
            sprite.position = initialPositionValue.cgPointValue
            
            // reset any children of this node as well
            resetSpritePositions(node: sprite)
        }
    }
}
