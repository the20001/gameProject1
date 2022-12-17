//
//  GameViewController.swift
//  GameProject
//
//  Created by Guest User on 12/16/22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var startOrResumeButton: UIButton!
    var gameScene : GameScene!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameScene = GameScene(size: view.bounds.size)
        gameScene.viewController = self
        let skView = self.view as!SKView
        skView.presentScene(gameScene)
        
    }
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        let v = self.view as!SKView?
        let gameScene = v?.scene as? GameScene
        if(gameScene?.gameState == .gameRunning){
            gameScene?.pause()
        }
        
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        if(gameScene.gameState == .gamePaused){
            displayRestartOrResumeButton()
        }
    }
    func updateScore(score: Int){
        scoreLabel.text = "Score: \(score)"
        
    }
    @IBAction func StartOrResumeGame(_ sender: Any) {
        let v = self.view as!SKView?
        let gameScene = v?.scene as? GameScene
        if(gameScene?.gameState == .noGame){
            gameScene?.startGame()
        }else if(gameScene?.gameState == .gamePaused){
            gameScene?.resumeGame()
        }
        startOrResumeButton.isEnabled = false
        startOrResumeButton.isHidden = true
    }
    func displayRestartOrResumeButton(){
        let v = self.view as!SKView?
        let gameScene = v?.scene as? GameScene
        if(gameScene?.gameState == .noGame){
            startOrResumeButton.setTitle("Restart?", for: .normal)
        }else if(gameScene?.gameState == .gamePaused){
            startOrResumeButton.setTitle("Resume?", for: .normal)
        }
        startOrResumeButton.isEnabled = true
        startOrResumeButton.isHidden  = false
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabBarVC = segue.destination as! UITabBarController
        let configVC = tabBarVC.viewControllers![0] as! ConfigVC
        configVC.gameScene = self.gameScene
    }
}

//actions and start, resume, and stop game
extension GameViewController{
    
}
