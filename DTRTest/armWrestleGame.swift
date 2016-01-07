//
//  armWrestleGame.swift
//  timerTest
//
//  Created by Dylan Sharkey on 11/19/15.
//  Copyright © 2015 Dylan Sharkey. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox
import AVFoundation


class armWrestleGame: GameObject {
    
    var delegate: GameViewDelegate
    var flag = false
    var max = Double(0.00)
    lazy var motionManager = CMMotionManager()
    
    init(delegate: GameViewDelegate) {
        self.delegate = delegate
    }
    
    func playSoundVibe(){
        let vibrateID: SystemSoundID = 4095
        AudioServicesPlaySystemSound (vibrateID)
    }
    
    func startGame() {
        delegate.updateInfoLabel("Arm Wrestling Game!!\nPosition your arm in a arm wrestling postion..\nPhone will vibrate when you are good to go!")
        if (motionManager.deviceMotionAvailable) && (motionManager.gyroAvailable){
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.gyroUpdateInterval = 0.1
            let queue = NSOperationQueue()
            dispatch_async(dispatch_get_main_queue(), {
            })
            motionManager.startDeviceMotionUpdatesToQueue(queue, withHandler:
                {data, error in
                    guard let data = data else{
                        return
                    }
                    if data.attitude.roll > -1.8 && data.attitude.roll < -1.4 || data.attitude.roll < 1.8 && data.attitude.roll > 1.4{
                        self.playSoundVibe()
                        self.motionManager.stopDeviceMotionUpdates()
                        self.motionManager.startGyroUpdatesToQueue(queue, withHandler:
                            {data, error in
                                guard let data = data else{
                                    return
                                }
                                let wrestleForce = data.rotationRate.x
                                if wrestleForce > 2 { //player has started to wrestle for the first time
                                    self.flag = true
                                    if wrestleForce > self.max {
                                        self.max = wrestleForce
                                    }
                                }
                                if wrestleForce < 0 && self.flag{
                                    //return victory or not
                                    self.motionManager.stopGyroUpdates()
                                    var message: String = ""
                                    var success: Bool = true
                                    if self.max > 8 {
                                        message = "Wow so strong~\n"
                                        success = true
                                    }
                                    else
                                    {
                                        message = "Too weak~\n"
                                        success = false
                                    }
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.delegate.updateInfoLabel("\(message)You had \(String(format:"%.2f", self.max)) max force~!)")
                                    })
                                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC)))
                                    dispatch_after(delayTime, dispatch_get_main_queue(), {
                                        self.delegate.roundComplete(success)
                                    })
                                }
                        })
                    }
            })
        }
        else{
            print("Device Attitude is not available")
        }
    }
}