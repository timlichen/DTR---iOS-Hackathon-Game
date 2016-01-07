import UIKit
import CoreMotion
import AudioToolbox
import AVFoundation


class screwDriverGame: GameObject {

    var delegate: GameViewDelegate
    lazy var motionManager = CMMotionManager()
    
    init(delegate: GameViewDelegate) {
        self.delegate = delegate
    }

  func playSoundVibe(){
    let systemSoundID: SystemSoundID = 1109
    let vibrateID: SystemSoundID = 4095
    AudioServicesPlaySystemSound (systemSoundID)
    AudioServicesPlaySystemSound (vibrateID)
  }
  
  func startGame() {
    let screwDepth = Int(arc4random_uniform(100)+20)
    var spin = 0
    var timer = 0.0
    var message = ""
    var success = false
    if motionManager.gyroAvailable{
      dispatch_async(dispatch_get_main_queue(), {
        self.delegate.updateInfoLabel("Quickly move your phone like turning a key or screwing in a lightbulb!")
        })
      motionManager.gyroUpdateInterval = 0.25
      let queue = NSOperationQueue()
      motionManager.startGyroUpdatesToQueue(queue, withHandler:
        {data, error in
          guard let data = data else{
            return
          }
          timer = timer + 1.0
          let power = Int(floor(data.rotationRate.y) )
          if power > 2{
              spin += power
          }
            //Game End
          if spin > screwDepth || timer > 25.0 {
            if timer > 25.0 {
                message = "Too slow~\n"
                success = false
            }
            else {
                message = "Way to go!\n"
                success = true
            }
            self.playSoundVibe()
            dispatch_async(dispatch_get_main_queue(), {
                let speed = (timer * 0.25)
                self.delegate.updateInfoLabel("\(message)It took you \(String(format:"%.2f", speed))seconds")
            })
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue(), {
                self.delegate.roundComplete(success)
            })
            self.motionManager.stopGyroUpdates()
          }
        }
      )
    } else {
      print("Gyroscope is not available")
    }
  }
}