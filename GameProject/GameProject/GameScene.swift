//
//  GameScene.swift
//  GameProject
//
//  Created by Guest User on 12/16/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    lazy var flappyBird: SKSpriteNode = createBird(size: self.size)
    var PipeMovementInterval: TimeInterval = 5.0
    let slowestPipeMovementInterval: TimeInterval = 10.0
    let fastestPipeMovementInterval: TimeInterval = 2.0
    
    let maxJumpSpeed: Float = 250.0
    let minJumpSpeed: Float = 50.0
    var currJumpSpeed: Float = 150.0
    var pipes = [(SKSpriteNode, SKSpriteNode, Bool)]()// the bool is used to detect whether the pipe pair has been scored or not
    var score: Int = 0
    enum GameState {
        case gameRunning
        case gamePaused
        case noGame
    }
    var viewController: GameViewController!
    public var gameState = GameState.noGame

    override func sceneDidLoad() {
        super.sceneDidLoad()
        flappyBird = createBird(size: self.size)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -7)
        self.scene?.physicsWorld.contactDelegate = self
        addChild(flappyBird)
        createPipePair()
        self.backgroundColor = SKColor.cyan
    }
    var birdSprite = SKSpriteNode(imageNamed: "Bird.png")
    override func didMove(to view: SKView) {
//        if(gameState == .gamePaused){
//            resumeGame()
//        }
    }
    override func willMove(from: SKView){//leaving game scene
        pause()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            flappyBird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: Int(currJumpSpeed)))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(userCollided()){
            
        }
        updatePipes()
    }
    func createPipePair(){
        if(gameState != .gameRunning){
            return
        }
        let upperPipe = SKSpriteNode(imageNamed: "upperPipe.png")
        let lowerPipe = SKSpriteNode(imageNamed: "lowerPipe.png")        ////upper pipe
        let size_ = CGSize(width: UIScreen.main.bounds.width * 0.3, height:UIScreen.main.bounds.height)
        
        upperPipe.size = size_
        let point = CGPoint(x: 0, y: 0.0)
        upperPipe.anchorPoint = point
        upperPipe.position  = CGPoint(x: size.width, y:size.height * Double.random(in: 0.4...0.9))
        self.addChild(upperPipe)
        //////////////// lower pipe
        lowerPipe.size = size_
        lowerPipe.anchorPoint = CGPoint(x:1, y: 1)
        let yPos = upperPipe.position.y  - size.height * 0.3
        let xPos = upperPipe.position.x + lowerPipe.size.width
        lowerPipe.position = CGPoint(x: xPos, y: yPos)
        self.addChild(lowerPipe)
        
        let movePipeOutOfScreen = SKAction.moveTo(x: -size.width - size_.width, duration: PipeMovementInterval)
        let removePipes = SKAction.removeFromParent()
        let allActions  = SKAction.sequence([movePipeOutOfScreen, removePipes])
        
        upperPipe.run(allActions)
        
        pipes += [(upperPipe, lowerPipe, false)]
    }
    var i = 0;
    func userCollided() -> Bool{
        if(flappyBird.position.y < 0.0 + flappyBird.size.height / 2 ||
           flappyBird.position.y > size.height - flappyBird.size.height / 2){
            flappyBird.physicsBody = nil
            return true
        }
        
        for i in 0 ..< pipes.count{
            //collision up
            if(flappyBird.position.x + flappyBird.size.width / 2.0 >= pipes[i].0.position.x && flappyBird.position.x  - flappyBird.size.width / 2.0 <= pipes[i].0.position.x + pipes[i].0.size.width
               && flappyBird.position.y + flappyBird.size.height / 2.0 >= pipes[i].0.position.y){
                return true
                //collision down
            }else if(flappyBird.position.x + flappyBird.size.width / 2.0 >= pipes[i].0.position.x && flappyBird.position.x - flappyBird.size.width / 2.0 <= pipes[i].0.position.x + pipes[i].0.size.width && flappyBird.position.y - flappyBird.size.height / 2.0 <= pipes[i].1.position.y){
                return true
            }
            //if not collided and the pipe is in range the update the score
            if(!pipes[i].2 && pipes[i].1.position.x < flappyBird.position.x){
                score +=  1
                viewController.updateScore(score: score)
                pipes[i].2 = true
            }

        }
        return false
    }
    func updatePipes(){//make sure the lower pipe is at the same position as the upper one
        if (gameState != .gameRunning){
            return
        }
        guard(!userCollided()) else{
            endGame()
            return
        }
        for pipe in pipes{
            pipe.1.position.x = pipe.0.position.x + pipe.1.size.width
        }
        if(pipes[pipes.count-1].0.position.x <= size.width * 0.2){
            createPipePair()
        }
        if(pipes[0].0.position.x < -pipes[0].0.size.width){
            pipes[0].1.run(SKAction.removeFromParent())
            pipes.remove(at: 0)
        }
        
    }
}
func createBird(size: CGSize) -> SKSpriteNode{
    let bird = SKSpriteNode(imageNamed: "Bird.png")
    bird.size = CGSize(width: size.width / 5.0, height:size.height / 10)
    bird.position = CGPoint(x: size.width * 0.3, y: size.height * 0.5)
    return bird
}
extension GameScene{
    func pause(){
        gameState = .gamePaused
        for i in 0 ..< pipes.count{
            pipes[i].1.isPaused = true
            pipes[i].0.isPaused = true
        }
        flappyBird.physicsBody = nil
    }
    func resumeGame(){
        gameState = .gameRunning
        
        let size_ = CGSize(width: UIScreen.main.bounds.width * 0.3, height:UIScreen.main.bounds.height)
        
        for i in 0 ..< pipes.count{
            pipes[i].1.isPaused = false
            pipes[i].0.isPaused = false
        }
        flappyBird.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Bird.png"), size: CGSize(width: size.width / 5.0, height:size.height / 10))
        flappyBird.physicsBody?.allowsRotation = false
        flappyBird.physicsBody?.isDynamic = true

    }
    func startGame(){
        gameState = .gameRunning
        //remove all pipes
        for i in 0 ..< pipes.count{
            pipes[i].0.removeFromParent()
            pipes[i].1.removeFromParent()
        }
        pipes = []
        //update score label
        score = 0
        viewController.updateScore(score:score)
        //reset flappyBird
        flappyBird.position = CGPoint(x: size.width * 0.3, y: size.height * 0.5)
        flappyBird.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Bird.png"), size: CGSize(width: size.width / 5.0, height:size.height / 10))
        flappyBird.physicsBody?.allowsRotation = false
        flappyBird.physicsBody?.isDynamic = true
        if(pipes.count == 0){
            createPipePair()
        }

    }
    func endGame(){
        gameState = .noGame
        for i  in 0 ..< pipes.count{
            pipes[i].1.removeAllActions()
            pipes[i].0.removeAllActions()
        }
        flappyBird.physicsBody = nil
        viewController?.displayRestartOrResumeButton()
    }
}
