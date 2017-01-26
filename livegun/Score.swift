//
//  Score.swift
//  livegun
//
//  Created by Marek Mako on 26/01/2017.
//  Copyright © 2017 Marek Mako. All rights reserved.
//

import Foundation


class Kills: AbstractScore {

    init() {
        super.init(userDefaultScoreKey: "k_kills_cnt")
    }
}

class Shares: AbstractScore {
    
    init() {
        super.init(userDefaultScoreKey: "k_shares_cnt")
    }
}

class AbstractScore {
    
    let userDefaults = UserDefaults.standard
    
    let kScore: String
    
    init(userDefaultScoreKey kScore: String) {
        self.kScore = kScore
    }
    
    private(set) var cnt: Int  {
        get {
            return userDefaults.integer(forKey: kScore)
        }
        set {
            userDefaults.set(newValue, forKey: kScore)
        }
    }

    func addScore(_ score: Int = 1) {
        cnt += score
    }
}
