//
//  Weapons.swift
//  livegun
//
//  Created by Marek Mako on 24/01/2017.
//  Copyright © 2017 Marek Mako. All rights reserved.
//

import UIKit
import AVFoundation


// MARK: - XPR50
class XPR50Type: BaseWeaponType {
    
    required init() {
        super.init()
        name = "XPR 50"
        classType = XPR50.self
    }
}
class XPR50: BaseWeapon {
    
    required init(gunLayer: CALayer, shootLayer: CALayer) {
        super.init(gunLayer: gunLayer, shootLayer: shootLayer, gunImage: #imageLiteral(resourceName: "rifle-xpr50-1").cgImage)
        
        audioPlayer = try? AVAudioPlayer(data: NSDataAsset(name: "XPR50-sound")!.data, fileTypeHint: AVFileTypeCoreAudioFormat)
        
        // shootAnimation.values = [insert here ...]
        
        gunAnimation.values = [
            #imageLiteral(resourceName: "rifle-xpr50-2").cgImage!,
            #imageLiteral(resourceName: "rifle-xpr50-3").cgImage!,
            
        ]
        
        lifeDemage = 0.1
    }
}



// MARK: - BaseWeapon
class BaseWeaponType {
    
    var name = "Some Weapon"
    
    var classType: BaseWeapon.Type?
    
    required init() {}
}
class BaseWeapon {
    
    var lifeDemage: Float = 0.05
    
    /// overide z child class
    var gunImage: CGImage?
    
    var audioPlayer: AVAudioPlayer?
    
    /// pripraveny na 5 obrazkov
    var shootAnimation: CAKeyframeAnimation!
    
    /// pripraveny na 2 obrazky
    var gunAnimation: CAKeyframeAnimation!
    
    let gunLayer: CALayer
    
    let shootLayer: CALayer
    
    required convenience init(gunLayer: CALayer, shootLayer: CALayer) {
        self.init(gunLayer: gunLayer, shootLayer: shootLayer, gunImage: nil)
    }
    
    init(gunLayer: CALayer, shootLayer: CALayer, gunImage: CGImage?) {
        self.gunLayer = gunLayer
        self.shootLayer = shootLayer
        self.gunImage = gunImage
        
        setupGun()
        setupShootAnimation()
        setupGunAnimation()
    }
    
    private func setupGun() {
        gunLayer.contents = gunImage
    }
    
    private func setupShootAnimation() {
        shootAnimation = CAKeyframeAnimation(keyPath: "contents")
        shootAnimation.calculationMode = kCAAnimationDiscrete
        shootAnimation.duration = 0.3
        shootAnimation.keyTimes = [0, 0.22, 0.58, 0.84, 1]
        shootAnimation.isAdditive = true
        shootAnimation.values = [
            #imageLiteral(resourceName: "shot1").cgImage!,
            #imageLiteral(resourceName: "shot2").cgImage!,
            #imageLiteral(resourceName: "shot3").cgImage!,
            #imageLiteral(resourceName: "shot4").cgImage!,
            #imageLiteral(resourceName: "shot5").cgImage!
        ]
    }
    
    private func setupGunAnimation() {
        gunAnimation = CAKeyframeAnimation(keyPath: "contents")
        gunAnimation.calculationMode = kCAAnimationDiscrete
        gunAnimation.duration = 0.3
        gunAnimation.keyTimes = [0, 1]
        gunAnimation.isAdditive = true
    }
    
    func onShoot() {
        playAudio()
        gunLayer.add(gunAnimation, forKey: nil)
        shootLayer.add(shootAnimation, forKey: nil)
    }
    
    private func playAudio() {
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }
}


