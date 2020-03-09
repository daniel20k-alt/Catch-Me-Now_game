//
//  GameScene.swift
//  Catch Me Now_game
//
//  Created by DDDD on 29/02/2020.
//  Copyright © 2020 MeerkatWorks. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var nextCandyLabel: SKLabelNode!
    var nextCandyImageLabel: SKSpriteNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    //Entering Editing mode
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let backgroundImage = SKSpriteNode(imageNamed: "background")
        backgroundImage.position = CGPoint(x: 512, y: 384)
        backgroundImage.blendMode = .replace //ignoring any transparencies
        backgroundImage.zPosition = -1  //makes this backgroundImage be placed behind everything else
        addChild(backgroundImage)  //adding the background
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)  //adding the Score Label
        
        nextCandyLabel = SKLabelNode(fontNamed: "Chalkduster")
        nextCandyLabel.text = "Next candy is: "
        nextCandyLabel.horizontalAlignmentMode = .right
        nextCandyLabel.position = CGPoint(x: 700, y: 700)
        addChild(nextCandyLabel)  //adding the Next Candy Label
        
//        nextCandyImageLabel = SKSpriteNode(imageNamed: "candy\(doneCandy)")
//        nextCandyImageLabel.position = CGPoint(x: 850, y: 700)
//        nextCandyImageLabel.physicsBody = SKPhysicsBody(rectangleOf: nextCandyImageLabel.size)
//        nextCandyImageLabel.physicsBody?.isDynamic = false
//        addChild(nextCandyImageLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)  //adding the Edit Label
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)  //adding physics simulation to the game
        physicsWorld.contactDelegate = self  //a delegate called when bodies collide
        
        var randomXPoints = [Int]()  //introducing random locations buckets for each game
        randomXPoints += [128, 384, 640, 896]
        randomXPoints.shuffle()
        
        makeSloth(at: CGPoint(x: randomXPoints[0], y: 0), bucketColour: "Green")      // a green bucket
        makeSloth(at: CGPoint(x: randomXPoints[1], y: 0), bucketColour: "Red")     // a red bucket
        makeSloth(at: CGPoint(x: randomXPoints[2], y: 0), bucketColour: "Pink")      //a pink bucket
        makeSloth(at: CGPoint(x: randomXPoints[3], y: 0), bucketColour: "Yellow")     //a yellow bucket
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }  //identifying any first touch that he user has made
        let locationUserTap = touch.location(in: self)  //find the location where the user had tapped
        
        let objects = nodes(at: locationUserTap)
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                //creating the additional objects here
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in:0...1), green: CGFloat.random(in:0...1), blue: CGFloat.random(in:0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 1...3)
                box.position = locationUserTap
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
                
            } else {
                //if not in editing mode, then creacreating and randomizing the candies that are thrown
                var typesOfCandies = [String]()
                var doneCandy = String()
                typesOfCandies += ["Blue", "Green", "Orange", "Pink", "White", "Yellow", "Red"]
                typesOfCandies.shuffle()
                doneCandy = typesOfCandies[0]
                print("Type of random candy color is \(doneCandy)")  //TEST
                
                var ball = SKSpriteNode(imageNamed: "candy\(doneCandy)")
                //TODO: vezi poate aici de modificat impactul intre ele
                
                //TODO: poate aici la fiecare ball tre de pus numele altul ca sa il recunoasca mai jos
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                ball.physicsBody?.restitution = 0.4 //how bounchy will the ball be
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 1  //notification of every single bounce, given the body interacts with everything
                ball.position = locationUserTap
                
                ball.name = "\(doneCandy)"
                print("The ball asigned name is \(ball.name)") //TEST
                addChild(ball)
  
            }
        }
    }
    
    func makeBouncer(at positionBouncer: CGPoint) {
        //adding bouncers for the balls to bounce from
        let bouncer = SKSpriteNode(imageNamed: "bouncer")  //getting the bouncer from the assets library
        bouncer.position = positionBouncer
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSloth(at positionSlot: CGPoint, bucketColour: String) {  //making slot and glowing effect
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if bucketColour == "Green" {
            
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")  //this seems to be useless
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGreen")
            slotBase = SKSpriteNode(imageNamed: "bucketGreen")
            //TODO: the bucket should be in fron of the glow
            slotBase.name = "\(bucketColour)"//??
            print("Testing: bucketColour is \(bucketColour)")
            
        } else if bucketColour == "Red" {
            slotGlow = SKSpriteNode(imageNamed: "slotGlowRed")
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotBase = SKSpriteNode(imageNamed: "bucketRed")
            slotBase.name = "\(bucketColour)"//??
            print("Testing: bucketColour is \(bucketColour)")
            
        } else if bucketColour == "Pink" {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowPink")
            slotBase = SKSpriteNode(imageNamed: "bucketPink")
            slotBase.name = "\(bucketColour)"//??
            print("Testing: bucketColour is \(bucketColour)")
            
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowYellow")
            slotBase = SKSpriteNode(imageNamed: "bucketYellow")
            slotBase.name = "\(bucketColour)" //??
            print("Testing: bucketColour is \(bucketColour)")
        }
        
        slotBase.position = positionSlot
        slotGlow.position = positionSlot
        
        //TODO: Candy dispare in momentul in care atinge rectangle of the bucket, poate de schimbat si de pus cand atinge baza de jos sa dispara? vezi la dissapear sau aici?
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10) //making the glow spin by 180 degrees
        let spinForever = SKAction.repeatForever(spin) //making the glow always spin
        slotGlow.run(spinForever)
    }
    
    //la coliziune - putem face if pentru celelalte candies, dar trebuie sa diferentiem si la coliziune
    //TODO: trebuie sa nimereasca fiecare candy in culoarea ei pentru +1, si daca e gresita -1. ISSUE diferentierea la coliziune la ambele
    
    //TODO: SA APARA CE CANDY VA APAREA, SA STIE USERUL INAINTE SA apese push.
    func collisionBetween(ball: SKNode, object: SKNode) {
        if ball.name == object.name {
            print("Else if ball.name IS YES equal, it is \(ball.name)")
            print("Else if object.name IS YES equal, it is \(object.name)")
            
            destroy(ball: object)
            score += 1  //add one if good
            
        } else if ball.name != object.name {
            print("Else if ball.name not equal, it is \(ball.name)")
            print("Else if object.name not equal, it is \(object.name)")
            
            destroy(ball: object)  //"destroy" func was created beneath this one
            score -= 1
        }
    }
    
    //ISSUE: daca apare ceva green - el distruge primul obiect de care se atinge!
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "Green" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeA.name == "Pink" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeA.name == "Red" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeA.name == "Blue" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeA.name == "Yellow" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeA.name == "White" {
            collisionBetween(ball: nodeA, object: nodeB)
            
            //                } else if nodeB.name == "Pink" {
            //                collisionBetween(ball: nodeA, object: nodeB)
            //                } else if nodeB.name == "Red" {
            //                collisionBetween(ball: nodeA, object: nodeB)
            //                } else if nodeB.name == "Blue" {
            //                collisionBetween(ball: nodeA, object: nodeB)
            //                } else if nodeB.name == "Yellow" {
            //                collisionBetween(ball: nodeA, object: nodeB)
            //                } else if nodeB.name == "White" {
            //                collisionBetween(ball: nodeA, object: nodeB)
            //                } else if nodeB.name == "Green" {
            //                collisionBetween(ball: nodeA, object: nodeB)
            
        }
    }
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position  //dispare in momentul intersectarii
            addChild(fireParticles)
            //TODO: add different colors to effects particles
        }
        ball.removeFromParent()
    }
}
