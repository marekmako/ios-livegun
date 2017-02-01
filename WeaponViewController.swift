//
//  WeaponViewController.swift
//  livegun
//
//  Created by Marek Mako on 26/01/2017.
//  Copyright © 2017 Marek Mako. All rights reserved.
//

import UIKit


class WeaponViewController: BaseViewController {
    
    /// from segue
    weak var mainVC: MainViewController!
    
    /// from segue
    var weaponType: BaseWeaponType!
    
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
            alert.addAction(UIAlertAction(title: "Watch video and grab it now", style: .default, handler: { _ in
                self.mainVC.selectedWeaponType = self.weaponType
                self.mainVC.dismiss(animated: true, completion: nil)
            }))
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
}
