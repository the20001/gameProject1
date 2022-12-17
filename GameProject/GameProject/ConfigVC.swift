//
//  ConfigVC.swift
//  GameProject
//
//  Created by Guest User on 12/16/22.
//

import Foundation
import UIKit
class ConfigVC: UIViewController{
    
    @IBOutlet weak var pipeSpeedLabel: UILabel!
    
    @IBOutlet weak var jumpSpeedLabel: UILabel!
    
    @IBOutlet weak var jumpSpeedSlider: UISlider!
    
    @IBOutlet weak var pipeSpeedSlider: UISlider!
    
    @IBOutlet weak var backgroundColorPicker: UIPickerView!
    
    let sliderMax: Float = 1.0
    let sliderMin: Float = 0.0
    var gameScene: GameScene?
    override func viewDidLoad(){
        super.viewDidLoad()
        print("loaded")
    }
    override func viewWillAppear(_ animated: Bool){
        var val =  sliderGivenDelay(delay: gameScene!.PipeMovementInterval, nrMin: Float(gameScene!.slowestPipeMovementInterval), nrMax:Float(gameScene!.fastestPipeMovementInterval))
        pipeSpeedSlider.value = val
        pipeSpeedLabel.text = String(format:"%1.2f", val*100) + "%"
        val = sliderGivenDelay(delay: TimeInterval(gameScene!.currJumpSpeed), nrMin: gameScene!.minJumpSpeed, nrMax: gameScene!.maxJumpSpeed)
        jumpSpeedSlider.value = val
        jumpSpeedLabel.text = String(format:"%3.0f", gameScene!.currJumpSpeed)
        
    }
    
    //================================================
    func sliderGivenDelay(delay: TimeInterval, nrMin: Float, nrMax: Float) -> Float {        // The slope
        let m = (nrMax - nrMin) / (sliderMin - sliderMax )
        // Cast ...
        let nrInt = Float(delay)
        // Function computation
        let sliderValue  = (nrInt - nrMax) / m
        // Return the correspoinding slider value
        return sliderValue
    }
    //================================================
    func delayGivenSlider(sliderValue: Float, nrMin: Float, nrMax: Float) -> TimeInterval {
        // The slope
        let m = (nrMax - nrMin) / (sliderMin - sliderMax )
        // Function computation - the inverse of delayToSlider
        let nrInt = m * sliderValue + nrMax
        // Return the correspoinding delay
        return TimeInterval(nrInt)
    }
    
    @IBAction func changeJumpSpeed(_ sender: UISlider) {
        // Get the slider's value
        let sliderValue = sender.value
        // Get the corresponding delay
        let nrMin = Float(gameScene!.minJumpSpeed)
        let nrMax = Float(gameScene!.maxJumpSpeed)
        let delay = delayGivenSlider(sliderValue: sliderValue, nrMin: nrMin, nrMax: nrMax)
        // UPDATE THE SPEED IN THE GameSceneVC object
        gameScene?.currJumpSpeed = Float(delay)
                                
        // Update the slider's value label
        jumpSpeedLabel.text = String(format:"%3.0f", gameScene!.currJumpSpeed)
        
    }
    
    @IBAction func changePipeSpeed(_ sender: UISlider) {
    }
    
}
