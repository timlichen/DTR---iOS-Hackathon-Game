//
//  MenuViewController.swift
//  timerTest
//
//  Created by Dylan Sharkey on 11/19/15.
//  Copyright © 2015 Dylan Sharkey. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, navControllerDelegate {
    
    @IBOutlet weak var singleRoundsLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        let user = User.all()[0]
        super.viewWillAppear(animated)
        singleRoundsLabel.text = "Hey \(user.name)-\nRounds Won: \(user.singleVictories)"
    }
    
    @IBAction func playerButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("gameSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gameSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! GameViewController
            controller.delegate = self
            if sender!.tag == 1 {
                controller.multiplayer = true
            }
            else {
                controller.multiplayer = false
            }
        }
    }
    
    func removeViewScene(scorePoints: Int) {
        //remove the top scene
        let user = User.all()[0]
        user.singleVictories += scorePoints
        user.save()
        dismissViewControllerAnimated(true, completion: nil)
    }

}
