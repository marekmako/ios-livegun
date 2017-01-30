//
//  WeaponPageViewController.swift
//  livegun
//
//  Created by Marek Mako on 26/01/2017.
//  Copyright © 2017 Marek Mako. All rights reserved.
//

import UIKit


class WeaponPageViewController: UIPageViewController {
    
    /// nastaveny zo segue
    weak var mainVC: MainViewController!
    
    fileprivate var currentVC: WeaponViewController!
    
    fileprivate lazy  var orderedVC: [WeaponViewController] = {
        func createWeaponController(weapon: BaseWeaponType) -> WeaponViewController {
            let weaponVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: WeaponViewController.self)) as! WeaponViewController
            weaponVC.weaponType = weapon
            weaponVC.mainVC = self.mainVC
            return weaponVC
        }
        
        return [
            createWeaponController(weapon: NambuType()),
            createWeaponController(weapon: P99Type()),
            createWeaponController(weapon: XPR50Type()),
            createWeaponController(weapon: FG42Type()),
            createWeaponController(weapon: MachineGunType()),
            createWeaponController(weapon: BazookaType()),
            createWeaponController(weapon: FlameMachineType()),
            createWeaponController(weapon: RPGType()),
        ]
    }()
}



// MARK: - LIFECYCLE
extension WeaponPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
            guard  mainVC != nil else {
                fatalError()
            }
        #endif

        dataSource = self
        
        currentVC = orderedVC.first!
        setViewControllers([currentVC], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
}



// MARK: UIPageViewControllerDataSource
extension WeaponPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! WeaponViewController
        let index = orderedVC.index(of: vc)!
        
        let prewIndex = index - 1
        
        guard prewIndex >= 0 else {
            return nil
        }
        
        currentVC = orderedVC[prewIndex]
        return currentVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! WeaponViewController
        let index = orderedVC.index(of: vc)!
        
        let nextIndex = index + 1
        
        guard nextIndex < orderedVC.count else {
            return nil
        }
        
        currentVC = orderedVC[nextIndex]
        return currentVC
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedVC.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return orderedVC.index(of: currentVC)!
    }
}
