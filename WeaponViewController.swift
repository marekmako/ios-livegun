//
//  WeaponViewController.swift
//  livegun
//
//  Created by Marek Mako on 26/01/2017.
//  Copyright © 2017 Marek Mako. All rights reserved.
//

import UIKit


class WeaponViewController: UIViewController {
    
    weak var mainVC: MainViewController!
    
    var weaponType: BaseWeaponType!
    
    @IBOutlet weak var weaponImage: UIImageView!
    
    @IBOutlet weak var weaponNameLabel: UILabel!
    
    @IBOutlet weak var weaponDemageLabel: UILabel!
    
    @IBAction func onSelectWeapon() {
        // TODO: reklama
        
        mainVC.selectedWeaponType = weaponType
        mainVC.dismiss(animated: true, completion: nil)
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
