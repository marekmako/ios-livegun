//
//  PhotoViewController.swift
//  livegun
//
//  Created by Marek Mako on 26/01/2017.
//  Copyright © 2017 Marek Mako. All rights reserved.
//

import UIKit


class PhotoViewController: UIViewController {
    
    /// from segue
    var videoVC: VideoViewController!
    /// from segue
    var photoImage: UIImage!
    /// from segue
    var hitEffects: HitEffects!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBAction func onCancel() {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}


// MARK: - LICECYCLE
extension PhotoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
            guard videoVC != nil else {
                fatalError()
            }
            guard photoImage != nil else {
                fatalError()
            }
            guard hitEffects != nil else {
                fatalError()
            }
        #endif

        // priprava na screen shot
        photoImageView.image = photoImage
        photoImageView.layer.addSublayer(hitEffects.effectsLayer)
        cancelButton.isHidden = true
        shareButton.isHidden = true
        
        // screen shot
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // upratujem po screenshote
        photoImageView.image = image
        videoVC.videoLayer.addSublayer(hitEffects.effectsLayer)
        cancelButton.isHidden = false
        shareButton.isHidden = false
    }
}
