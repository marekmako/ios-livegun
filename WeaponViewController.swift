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
    
    @IBOutlet weak var weaponNameLabel: UILabel!
    
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
        
        weaponNameLabel.text = weaponType.name
    }
}
