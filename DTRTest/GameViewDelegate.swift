//
//  GameViewDelegate.swift
//  timerTest
//
//  Created by Dylan Sharkey on 11/19/15.
//  Copyright © 2015 Dylan Sharkey. All rights reserved.
//

import UIKit

protocol GameViewDelegate: class {
    func updateInfoLabel(textToInstert: String)
    func updateBGColor(newBGColor: UIColor)
    func roundComplete(pass: Bool)
}
