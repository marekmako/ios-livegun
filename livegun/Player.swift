//
//  Player.swift
//  livegun
//
//  Created by Marek Mako on 31/01/2017.
//  Copyright © 2017 Marek Mako. All rights reserved.
//

import Foundation
import GameKit


// MARK: - Authentificator
class Authentificator {
    
    static let shared = Authentificator()
    
    static let errorNotificationName = Notification.Name("PlayerAuthentificator.errorNotificationName")
    var error: Error?
    
    static let presentVCNotificationName = Notification.Name("PlayerAuthentificator.presentAuthetificationVCNotificationName")
    var authentificationViewController: UIViewController?
    
    static let authentificatedNotificationName = Notification.Name("PlayerAuthentificator.authentificatedLocalPlayerNotificationName")
    var authentificatedLocalPlayer: GKLocalPlayer?
    
    private init() {}
    
    func isAuthenticated() -> Bool {
        return GKLocalPlayer.localPlayer().isAuthenticated
    }
    
    func authentificate() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        if localPlayer.isAuthenticated {
            NotificationCenter.default.post(name: Authentificator.authentificatedNotificationName, object: self)
            
        } else {
            localPlayer.authenticateHandler = { (viewController: UIViewController?, error: Error?) in
                guard error == nil else {
                    self.error = error
                    #if DEBUG
                        print("Authentificator.authentificate", error!.localizedDescription)
                    #endif
                    NotificationCenter.default.post(name: Authentificator.errorNotificationName, object: self)
                    return
                }
                
                if viewController != nil {
                    self.authentificationViewController = viewController
                    NotificationCenter.default.post(name: Authentificator.presentVCNotificationName, object: self)
                    
                    
                } else if localPlayer.isAuthenticated {
                    self.authentificatedLocalPlayer = localPlayer
                    NotificationCenter.default.post(name: Authentificator.authentificatedNotificationName, object: self)
                    
                } else {
                    #if DEBUG
                        fatalError()
                    #endif
                }
            }
        }
    }
}


// MARK: - SCORE
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
