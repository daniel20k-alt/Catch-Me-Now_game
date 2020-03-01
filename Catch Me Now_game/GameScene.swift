//
//  GameScene.swift
//  Catch Me Now_game
//
//  Created by DDDD on 29/02/2020.
//  Copyright © 2020 MeerkatWorks. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        let backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.position = CGPoint(x: 512, y: 384)
        backgroundImage.blendMode = .replace //ignoring any transparencies
        backgroundImage.zPosition = -1  //makes this backgroundImage be placed behind everything else
        addChild(backgroundImage)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)  // adding physics simulation
        physicsWorld.contactDelegate = self  //a delegate called when bodies collide
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        makeSloth(at: CGPoint(x: 128, y: 0), isGood: true)      // a green slot
        makeSloth(at: CGPoint(x: 384, y: 0), isGood: false)     // a red slot
        makeSloth(at: CGPoint(x: 640, y: 0), isGood: true)      //a green slot
        makeSloth(at: CGPoint(x: 896, y: 0), isGood: false)     //a red slot
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }  //identifying any first touch that he user has made
        let locationUserTap = touch.location(in: self)  //find the location where the user had tapped
    
       let ball = SKSpriteNode(imageNamed: "candyRed")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        ball.physicsBody?.restitution = 0.4 //how bounchy will the ball be
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0  //notification of every single bounce, given the body interacts with everything
        ball.position = locationUserTap
        ball.name = "ball"
        addChild(ball)
    }
    
    func makeBouncer(at positionBouncer: CGPoint) {
        //adding bouncers for the balls to bounce from
        let bouncer = SKSpriteNode(imageNamed: "bouncer")  //getting the bouncer from the assets library
        bouncer.position = positionBouncer
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSloth(at positionSlot: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")  //the green slotBase
             slotBase = SKSpriteNode(imageNamed: "bucketGreen")      // YOYO TESTING BUCKET
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")  //the red slotBase
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = positionSlot
        slotGlow.position = positionSlot
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10) //making it spin by 180*
        let spinForever = SKAction.repeatForever(spin) //making it always spin
        slotGlow.run(spinForever)
    }
    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
        } else if object.name == "bad" {
            destroy(ball: ball)
        }
    }
    
    func destroy(ball: SKNode) {
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
  
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
}
