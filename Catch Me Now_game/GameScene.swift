//
//  GameScene.swift
//  Catch Me Now_game
//
//  Created by DDDD on 29/02/2020.
//  Copyright © 2020 MeerkatWorks. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.position = CGPoint(x: 512, y: 384)
        backgroundImage.blendMode = .replace //ignoring any transparencies
        backgroundImage.zPosition = -1  //makes this backgroundImage be placed behind everything else
        addChild(backgroundImage)
    }
}
