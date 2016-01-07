//
//  ViewController.swift
//  Bouncer
//
//  Created by Raymond Luu on 11/19/15.
//  Copyright © 2015 Raymond Luu. All rights reserved.
//

import UIKit
import QuartzCore
import CoreMotion
import AudioToolbox
import AVFoundation

class ballHoleGame: GameObject {
    
    var delegate: GameViewDelegate
    var ballDelegate: newViewImageDelegate
    var animator: UIDynamicAnimator
    var timer = 0.0
    
    init(delegate: GameViewDelegate, ball: newViewImageDelegate, animu: UIDynamicAnimator) {
        self.delegate = delegate
        self.ballDelegate = ball
        self.animator = animu
    }
    
    lazy var motionManager = CMMotionManager()
    
    let bouncer = BouncerBehavior()
    var redBlock: UIView?
    var greenBlock: UIView?
    
    func playSoundVibe(){
        let systemSoundID: SystemSoundID = 1109
        let vibrateID: SystemSoundID = 4095
        AudioServicesPlaySystemSound (systemSoundID)
        AudioServicesPlaySystemSound (vibrateID)
    }
    
    func startGame() {
        delegate.updateInfoLabel("Try to get to red ball to collide with the green one!")
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(4.0 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue(), {
            self.delegate.updateInfoLabel("")
            self.begin()
        })
    }
    
    
    func begin() {
        animator.addBehavior(bouncer)
        var message = ""
        var success = false
        if redBlock == nil {
            redBlock = ballDelegate.addBlock()
            redBlock?.backgroundColor = UIColor.redColor()
            redBlock?.layer.cornerRadius = redBlock!.frame.size.width/2
            redBlock?.clipsToBounds = true
            redBlock?.layer.borderColor = UIColor.redColor().CGColor
            redBlock?.layer.borderWidth = 5.0
            bouncer.addBlock(redBlock!)
        }
        if greenBlock == nil {
            greenBlock = ballDelegate.addBlock()
            greenBlock?.backgroundColor = UIColor.greenColor()
            greenBlock?.layer.cornerRadius = greenBlock!.frame.size.width/2
            greenBlock?.clipsToBounds = true
            greenBlock?.layer.borderColor = UIColor.greenColor().CGColor
            greenBlock?.layer.borderWidth = 5.0
        }
        if motionManager.accelerometerAvailable {
            dispatch_async(dispatch_get_main_queue(), {
            })
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()){ (data, _) -> Void in
                self.timer = self.timer + 1.0
                self.bouncer.gravity.gravityDirection = CGVector(dx: data!.acceleration.x, dy: -data!.acceleration.y)
                self.motionManager.accelerometerUpdateInterval = 0.1
                
                // only two views to worry about
                if CGRectIntersectsRect(self.redBlock!.frame, self.greenBlock!.frame) || self.timer > 30.0 {
                    self.bouncer.removeBlock(self.redBlock!)
                    self.bouncer.removeBlock(self.greenBlock!)
                    //end game
                    if self.timer > 30.0 {
                        message = "Too slow~\n"
                        success = false
                    }
                    else {
                        message = "Way to go!\n"
                        success = true
                    }
                    self.playSoundVibe()
                    dispatch_async(dispatch_get_main_queue(), {
                        let speed = (self.timer * 0.1)
                        self.delegate.updateInfoLabel("\(message)It took you \(String(format:"%.2f", speed))seconds")
                    })
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue(), {
                        self.delegate.roundComplete(success)
                    })

                    self.motionManager.stopAccelerometerUpdates()
                }
            }
        }
    }
}

