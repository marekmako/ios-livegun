//
//  MainViewController.swift
//  livegun
//
//  Created by Marek Mako on 25/01/2017.
//  Copyright © 2017 Marek Mako. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    fileprivate let kills = Kills()
    
    /// nastavene po unwinde z WeaponViewController, kde si hrac vybral zbran po pouziti vo videoVC je zbran vynulovana
    var selectedWeaponType: BaseWeaponType?
    
    @IBOutlet weak var killedLabel: UILabel!
}

// MARK: - LIFECYCLE
extension MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if selectedWeaponType != nil {
            performSegue(withIdentifier: "VideoViewControllerSegue", sender: nil)
        }
        
        killedLabel.text = "\(kills.cnt)"
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let weaponPageVC = segue.destination as? WeaponPageViewController {
            weaponPageVC.mainVC = self
            
        } else if let videoVC = segue.destination as? VideoViewController {
            videoVC.mainVC = self
            videoVC.weaponType = selectedWeaponType!.classType!
            selectedWeaponType = nil
        }
    }
}
