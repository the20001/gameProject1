//
//  Structures.swift
//  GameProject
//
//  Created by Guest User on 12/16/22.
//

import Foundation
import GameplayKit

let birdBitMask: UInt32 = 0b0000
let upperPipeBitMask: UInt32 = 0b0001
let lowerPipeBitMask: UInt32 = 0b0010
class Bird: SKNode{
    var sprite = SKSpriteNode(imageNamed: "Bird.png")
    override init(){
        super.init()
        sprite.size = CGSize(width: UIScreen.main.bounds.width / 5.0, height:UIScreen.main.bounds.height / 10)
        self.position = CGPoint(x: UIScreen.main.bounds.width * 0.3, y: UIScreen.main.bounds.height * 0.5)
        self.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Bird.png"), size: CGSize(width: UIScreen.main.bounds.width / 5.0, height:UIScreen.main.bounds.height / 10))
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.isDynamic = true
        addChild(sprite)
        
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("Error with Bird")
    }
}
class PipePair: SKNode{
    var upperPipe = SKSpriteNode(imageNamed: "upperPipe.png")
    var lowerPipe = SKSpriteNode(imageNamed: "lowerPipe.png")
    override init(){
        super.init()
        //upperPipe setUp
        let size_ = CGSize(width: UIScreen.main.bounds.width * 0.3, height:UIScreen.main.bounds.height)
        upperPipe.size = size_
        upperPipe.position = CGPoint(x: UIScreen.main.bounds.width + upperPipe.size.width / 2.0, y: UIScreen.main.bounds.height * 0.4 )//Double.random(in: 0.4...0.9)) // spawn out of Screen
        let point = CGPoint(x: 0.5, y: 0.0)
        upperPipe.anchorPoint = point
//        upperPipe.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "lowerPipe.png"), size: size_)
//        upperPipe.physicsBody?.affectedByGravity = false
//        upperPipe.physicsBody?.isDynamic = false
//        upperPipe.physicsBody?.allowsRotation = false
        addChild(upperPipe)
        ///////////////////////////////
        ///lower Pipe Setup
        ///
        lowerPipe.size = size_
        lowerPipe.anchorPoint = CGPoint(x:0.5, y: 1)
        let yPos = upperPipe.position.y  - UIScreen.main.bounds.height * 0.3
        let xPos = UIScreen.main.bounds.width + lowerPipe.size.width / 2.0
        lowerPipe.position = CGPoint(x: xPos, y: yPos)
//        lowerPipe.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "lowerPipe.png"), size:  size_)
//        lowerPipe.physicsBody?.affectedByGravity = false
//        lowerPipe.physicsBody?.allowsRotation = false
//        lowerPipe.physicsBody?.isDynamic = false
        print(lowerPipe.position.y)
        addChild(lowerPipe)
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("Error with pipes")
    }
}


