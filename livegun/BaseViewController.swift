//
//  BaseViewController.swift
//  livegun
//
//  Created by Marek Mako on 31/01/2017.
//  Copyright © 2017 Marek Mako. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var authentificatorVCNotification: NSObjectProtocol?

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authentificatorVCNotification = NotificationCenter.default.addObserver(forName: Authentificator.presentVCNotificationName, object: nil, queue: .main) { [unowned self] (notification: Notification) in
            if let authentificator = notification.object as? Authentificator {
                self.present(authentificator.authentificationViewController!, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if authentificatorVCNotification != nil {
            NotificationCenter.default.removeObserver(authentificatorVCNotification!)
        }
    }
}
