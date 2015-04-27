//
//  UpgradesSingleton.swift
//  LhamaGame
//
//  Created by Ricardo Hochman on 16/04/15.
//  Copyright (c) 2015 Ricardo Hochman. All rights reserved.
//

import UIKit

class UpgradesSingleton: NSObject {
    let defaults = NSUserDefaults.standardUserDefaults()
    static let sharedInstance = UpgradesSingleton()
    
    var gameScore: Int = 0
    var multiplierClick: Int = 1
    var costMultiClick: Int = 100
    var multiplierTimer: Int = 0
    var costMultiTimer: Int = 200
    var multiplierTimerPlus: Int = 0
    var costMultiTimerPlus: Int = 300000
    
    func incrementGameScore() {
        self.gameScore += self.multiplierClick
        defaults.setObject(self.gameScore, forKey: "gameScore")
        self.gameScore = defaults.integerForKey("gameScore")
    }
    
    func incrementMultiplierClick() {
        self.multiplierClick = self.multiplierClick * 2
        defaults.setObject(self.multiplierClick, forKey: "multiplierClick")
        self.multiplierClick = defaults.integerForKey("multiplierClick")

    }
    
    func incrementCostMultiplierClick() {
        self.costMultiClick = Int(Double(self.costMultiClick) * 2.5)
        defaults.setObject(self.costMultiClick, forKey: "costMultiClick")
        self.costMultiClick = defaults.integerForKey("costMultiClick")
    }
    
    func incrementMultiplierTimer() {
        if multiplierTimer == 0 {
            multiplierTimer = 2
        }
        else {
            multiplierTimer = Int(Double(multiplierTimer) * 1.5)
        }
        defaults.setObject(self.multiplierTimer, forKey: "multiplierTimer")
        self.multiplierTimer = defaults.integerForKey("multiplierTimer")
        
    }
    
    func incrementCostMultiplierTimer() {
        self.costMultiTimer = Int(Double(self.costMultiTimer) * 2.5)
        defaults.setObject(self.costMultiTimer, forKey: "costMultiTimer")
        self.costMultiTimer = defaults.integerForKey("costMultiTimer")
    }
    
    func incrementMultiplierTimerPlus() {
        if multiplierTimerPlus == 0 {
            multiplierTimerPlus = 42
        }
        else {
            multiplierTimerPlus = Int(Double(multiplierTimerPlus) * 2)
        }
        defaults.setObject(self.multiplierTimerPlus, forKey: "multiplierTimerPlus")
        self.multiplierTimerPlus = defaults.integerForKey("multiplierTimerPlus")
        
    }
    
    func incrementCostMultiplierTimerPlus() {
        self.costMultiTimerPlus = Int(Double(self.costMultiTimerPlus) * 2.5)
        defaults.setObject(self.costMultiTimerPlus, forKey: "costMultiTimerPlus")
        self.costMultiTimerPlus = defaults.integerForKey("costMultiTimerPlus")
    }


    func recuperarValores() {
        self.gameScore = defaults.integerForKey("gameScore")
        self.multiplierClick = defaults.integerForKey("multiplierClick")
        self.costMultiClick = defaults.integerForKey("costMultiClick")
        self.multiplierTimer = defaults.integerForKey("multiplierTimer")
        self.costMultiTimer = defaults.integerForKey("costMultiTimer")
        self.multiplierTimerPlus = defaults.integerForKey("multiplierTimerPlus")
        self.costMultiTimerPlus = defaults.integerForKey("costMultiTimerPlus")
    }


    
}
