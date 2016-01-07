//
//  ViewController.swift
//  timerTest
//
//  Created by Dylan Sharkey on 11/18/15.
//  Copyright © 2015 Dylan Sharkey. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox
import AVFoundation

class GameViewController: UIViewController, GameViewDelegate, newViewImageDelegate {
    @IBOutlet weak var infoTextLabel: UILabel!
    
    var delegate: navControllerDelegate?
    var multiplayer: Bool?
    var currentGame: GameObject?
    var score = 0
    var currentRound = 1
    let numberOfRounds = 5
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        queueNewGame()
    }
    
    func queueNewGame() {
        if multiplayer! {
            //generate a random number for minigames later
            let miniGame = 1
            switch(miniGame) {
            case 0:
                break
            case 1:
                currentGame = pickupPhoneGame(delegate: self)
            default:
                print("Some Multiplayer game")
            }
        }
        else {
            //generate a random number for minigames later
            let miniGame = Int(arc4random_uniform(4))
            switch(miniGame) {
            case 0:
                currentGame = armWrestleGame(delegate: self)
            case 1:
                currentGame = pickupPhoneGame(delegate: self)
            case 2:
                let animator: UIDynamicAnimator = { UIDynamicAnimator(referenceView: self.view) }()
                currentGame = ballHoleGame(delegate: self, ball: self, animu: animator)
            default:
                currentGame = screwDriverGame(delegate: self)
            }
        }
        currentGame?.startGame()
    }
    
    func endGame() {
        infoTextLabel.text = "Game is over~\n You won \(score) rounds!"
        
        //after 7 seconds clear the game screen
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(7.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue(), {
            self.delegate?.removeViewScene(self.score)
        })
    }
    
    func roundComplete(pass: Bool) {
        if pass {
            score++
        }
        currentRound++
        print(currentRound)
        if currentRound > numberOfRounds {
            endGame()
        }
        else {
            infoTextLabel.text = "Now starting Round \(currentRound)!"
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue(), {
                self.queueNewGame()
            })
            
        }
        
    }
    
    struct Constants {
        static let BlockSize = CGSize(width: 40, height: 40)
    }
    
    func addBlock() -> UIView {
                let block = UIView(frame: CGRect(origin: CGPoint.zero, size: Constants.BlockSize))
                let centerX = arc4random_uniform(UInt32(view.bounds.maxX) - 50) + 50
                let centerY = arc4random_uniform(UInt32(view.bounds.maxY) - 50) + 50
                block.center = CGPoint(x: CGFloat(centerX), y: CGFloat(centerY))
                view.addSubview(block)
                return block
    }
    
    //update infoTextLabel to the contained string
    //maybe add 2 additional parameters in the future so size and color or text can be set
    func updateInfoLabel(textToInstert: String) {
        infoTextLabel.text = textToInstert
    }
    
    //update this views background color
    func updateBGColor(newBGColor: UIColor) {
        //doesnt do anything just yet
    }
    
}


