//
//  navControllerDelegate.swift
//  timerTest
//
//  Created by Dylan Sharkey on 11/19/15.
//  Copyright © 2015 Dylan Sharkey. All rights reserved.
//

import Foundation

protocol navControllerDelegate: class {
    //destroys the top view scene
    func removeViewScene(scorePoints: Int)
}