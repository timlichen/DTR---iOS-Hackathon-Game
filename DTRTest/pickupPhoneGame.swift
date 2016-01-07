//
//  pickupPhoneGame.swift
//  timerTest
//
//  Created by Dylan Sharkey on 11/19/15.
//  Copyright © 2015 Dylan Sharkey. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox
import AVFoundation

class pickupPhoneGame: GameObject {
    
    var delegate: GameViewDelegate
    
    init(delegate: GameViewDelegate) {
        self.delegate = delegate
    }
    
    lazy var motionManager = CMMotionManager()
    var onTableCheckCounter = 1
    
    var startTime = NSDate()
    var elapsedTime = 0.0
    
    func soundsVibe(){
        let systemSoundID: SystemSoundID = 1106
        let systemVibe: SystemSoundID = 4095
        AudioServicesPlaySystemSound(systemSoundID)
        AudioServicesPlaySystemSound(systemVibe)
    }
    
    //game loop for this minigame, return true whe  it is finished
    func startGame() {
        if motionManager.accelerometerAvailable{
            //infoTextLabel.text = "Please put you phone down, face-up, on the table."
            delegate.updateInfoLabel("Please put you phone down, face-up, on the table.")
            motionManager.accelerometerUpdateInterval = 0.25
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {data, error in
                    
                    guard let data = data else{
                        return
                    }
                    if data.acceleration.z < -1.00 && data.acceleration.z > -1.025   {
                        self.onTableCheckCounter++
                        if self.onTableCheckCounter == 10
                        {
                            self.motionManager.stopAccelerometerUpdates()
                            self.startDelayTimer()
                        }
                    }
                    else
                    {
                        self.onTableCheckCounter = 1
                    }
                }
            )
        } else {
            print("Accelerometer is not available")
        }
    }
    
    func startDelayTimer () {
        dispatch_async(dispatch_get_main_queue(), {
            self.delegate.updateInfoLabel("Pick up phone when it vibrates")
        })
        let randomTimer = Double(arc4random_uniform(5) + 3)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(randomTimer * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue(), {
            self.delegate.updateBGColor(UIColor.blueColor())
            self.starterGun()
        })
    }
    
    func starterGun() {
        //start clock time
        self.startTime = NSDate()
        
        //trigger sound and vibrate
        self.soundsVibe()
        
        //stop clock when motion detected
        if motionManager.accelerometerAvailable{
            motionManager.accelerometerUpdateInterval = 0.25
            let queue = NSOperationQueue()
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {data, error in
                    guard let data = data else{
                        return
                    }
                    if data.acceleration.z > -0.90 || data.acceleration.z < -1.3  {
                        self.motionManager.stopAccelerometerUpdates()
                        //return elapsed time
                        self.elapsedTime = self.startTime.timeIntervalSinceNow
                        //self.infoTextLabel.text = "Your reaction time was \(abs(self.elapsedTime))"
                        dispatch_async(dispatch_get_main_queue(), {
                            //check if you made it in time
                            var message: String = ""
                            var success: Bool = true
                            if abs(self.elapsedTime) <= 0.7 {
                                message = "Well done~\n"
                                success = true
                            }
                            else
                            {
                                message = "Too slow~\n"
                                success = false
                            }
                            self.delegate.updateInfoLabel("\(message)Your reaction time was \(String(format:"%.2f", self.elapsedTime))")
                            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC)))
                            dispatch_after(delayTime, dispatch_get_main_queue(), {
                                self.delegate.roundComplete(success)
                            })
                        })
                    }
                }
            )
        } else {
            print("Accelerometer is not available")
        }
    }
}
