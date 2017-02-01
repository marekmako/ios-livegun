//
//  WeaponViewController.swift
//  livegun
//
//  Created by Marek Mako on 26/01/2017.
//  Copyright © 2017 Marek Mako. All rights reserved.
//

import UIKit
import GoogleMobileAds


class WeaponViewController: BaseViewController {
    
    /// from segue
    weak var mainVC: MainViewController!
    
    /// from segue
    var weaponType: BaseWeaponType!
    
    fileprivate var rewardUserNotification: NSObjectProtocol?
    fileprivate var rewardAdIsPlaying = false
    
    fileprivate let killed = Kills()
    
    @IBOutlet weak var weaponImage: UIImageView!
    
    @IBOutlet weak var weaponNameLabel: UILabel!
    
    @IBOutlet weak var weaponDemageLabel: UILabel!
    
    @IBAction func onSelectWeapon() {
        if killed.cnt >= weaponType.requiredKillsForFree {
            mainVC.selectedWeaponType = weaponType
            mainVC.dismiss(animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "\(weaponType.name)\nrequires \(weaponType.requiredKillsForFree) kills", message: "Remaining \(weaponType.requiredKillsForFree - killed.cnt)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK, I try another weapon", style: .destructive, handler: nil))
            
            if RewardAd.shared.isReady() {
                alert.addAction(UIAlertAction(title: "Watch video and grab it now", style: .default, handler: { [unowned self] _ in
                    self.rewardAdIsPlaying = true
                    RewardAd.shared.present(from: self)
                }))
            }
            
            present(alert, animated: true, completion: nil)
        }
    }
}



// MARK: - LICECYCLE
extension WeaponViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        #if DEBUG
            guard mainVC != nil else {
                fatalError()
            }
            guard weaponType != nil else {
                fatalError()
            }
        #endif
        
        weaponImage.image = weaponType.image
        weaponNameLabel.text = weaponNameLabel.text?.replacingOccurrences(of: "%@", with: weaponType.name)
        weaponDemageLabel.text  = weaponDemageLabel.text?.replacingOccurrences(of: "%@", with: "\(weaponType.demage!)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rewardAdIsPlaying = false
        
        if rewardUserNotification == nil {
            rewardUserNotification = NotificationCenter.default.addObserver(forName: RewardAd.shared.rewardUserNotificationName, object: nil, queue: .main, using: { [weak self] (_) in
                self?.rewardAdIsPlaying = false
                self?.mainVC.selectedWeaponType = self?.weaponType
                self?.mainVC.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if rewardUserNotification != nil && !rewardAdIsPlaying {
            NotificationCenter.default.removeObserver(rewardUserNotification!)
        }
    }
}
