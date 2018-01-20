//
//  EncounterManager.swift
//  Charles Escapes the Antarctic
//
//  Created by Daniel Pratt on 1/20/18.
//  Copyright © 2018 Daniel Pratt. All rights reserved.
//

import SpriteKit

class EncounterManager {
    // store encounter scene names
    let encounterNames: [String] = [
        "EncounterBats"
    ]
    
    // Create array for nodes
    var encounters: [SKNode] = []
    
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
        }
    }
    
    func addEncountersToWorld(world: SKNode) {
        for (index, encounter) in encounters.enumerated() {
            // spawn encounters with increasing hight so they don't collide
            encounter.position = CGPoint(x: -2000, y: index * 1000)
            world.addChild(encounter)
        }
    }
}
