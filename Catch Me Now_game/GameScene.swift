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
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)  // adding physics simulation
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }  //identifying any first touch that he user has made
        let locationUserTap = touch.location(in: self)  //find the location where the user had tapped
    
        let box = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64))  //creating a custom box
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64)) //give it a physicsBox of the size of the box itself
        
        box.position = locationUserTap  //locating the box at the user first tap position
        addChild(box)  //adding the box on the screen
    }
    
    
    
    
    
    
}
