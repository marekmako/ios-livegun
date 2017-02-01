//
//  Weapons.swift
//  livegun
//
//  Created by Marek Mako on 24/01/2017.
//  Copyright © 2017 Marek Mako. All rights reserved.
//

import UIKit
import AVFoundation



// MARK: - Machine Gun
class MachineGunType: BaseWeaponType {
    
    required init() {
        super.init()
        name = "Machine Gun"
        classType = MachineGun.self
        demage = 50
        image = #imageLiteral(resourceName: "machine-gun-profile")
        requiredKillsForFree = 1200
    }
}
class MachineGun: BaseWeapon {
    
    required init(gunLayer: CALayer, shootLayer: CALayer) {
        super.init(gunLayer: gunLayer, shootLayer: shootLayer)
        
        gunImage = #imageLiteral(resourceName: "machinegun-1").cgImage
        
        soundName = "machine-gun-sound"
        
        shootAnimation.values = [
            #imageLiteral(resourceName: "machine-gun-shot1").cgImage!,
            #imageLiteral(resourceName: "machine-gun-shot2").cgImage!,
            #imageLiteral(resourceName: "machine-gun-shot3").cgImage!,
            #imageLiteral(resourceName: "machine-gun-shot4").cgImage!,
            #imageLiteral(resourceName: "machine-gun-shot5").cgImage!,
            #imageLiteral(resourceName: "machine-gun-shot6").cgImage!,
        ]
        shootAnimation.duration = 0.6
        shootAnimation.keyTimes = [0, 0.3, 0.5, 0.75, 0.9, 1]
        
        gunAnimation.values = [
            #imageLiteral(resourceName: "machinegun-2").cgImage!,
            #imageLiteral(resourceName: "machinegun-3").cgImage!,
            #imageLiteral(resourceName: "machinegun-2").cgImage!,
            #imageLiteral(resourceName: "machinegun-3").cgImage!,
        ]
        gunAnimation.duration = 0.6
        gunAnimation.keyTimes = [0, 0.4, 0.7, 1]
        
        lifeDemage = 0.5
        
        hitEffectsIndex = 6
        
        setupGun()
    }
}




// MARK: - RPG
class RPGType: BaseWeaponType {
    
    required init() {
        super.init()
        name = "RPG"
        classType = RPG.self
        demage = 70
        image = #imageLiteral(resourceName: "rpg-profile")
    }
}
class RPG: BaseWeapon {
    
    required init(gunLayer: CALayer, shootLayer: CALayer) {
        super.init(gunLayer: gunLayer, shootLayer: shootLayer)
        
        gunImage = #imageLiteral(resourceName: "rpg-1").cgImage
        
        soundName = "rpg-sound"
        
        shootAnimation.values = [
            #imageLiteral(resourceName: "bazooka-shoot1").cgImage!,
            #imageLiteral(resourceName: "bazooka-shoot2").cgImage!,
            #imageLiteral(resourceName: "bazooka-shoot3").cgImage!,
            #imageLiteral(resourceName: "bazooka-shoot4").cgImage!,
            #imageLiteral(resourceName: "bazooka-shoot5").cgImage!,
        ]
        shootAnimation.duration = 0.3
        shootAnimation.keyTimes = [0, 0.3, 0.5, 0.8, 1]
        
        gunAnimation.values = [
            #imageLiteral(resourceName: "rpg-2").cgImage!,
            #imageLiteral(resourceName: "rpg-3").cgImage!,
        ]
        
        lifeDemage = 0.7
        
        hitEffectsIndex = 9
        
        setupGun()
    }
}



// MARK: - Flame Machine
class FlameMachineType: BaseWeaponType {
    
    required init() {
        super.init()
        name = "Flame Machine"
        classType = FlameMachine.self
        demage = 35
        image = #imageLiteral(resourceName: "flame-machine-profile")
        requiredKillsForFree = 500
    }
}
class FlameMachine: BaseWeapon {
    
    required init(gunLayer: CALayer, shootLayer: CALayer) {
        super.init(gunLayer: gunLayer, shootLayer: shootLayer)
        
        gunImage = #imageLiteral(resourceName: "flame-machine-1").cgImage
        
        soundName = "flame-machine-sound"
        
        shootAnimation.values = [
            #imageLiteral(resourceName: "flame-machine-shot1").cgImage!,
            #imageLiteral(resourceName: "flame-machine-shot2").cgImage!,
            #imageLiteral(resourceName: "flame-machine-shot3").cgImage!,
            #imageLiteral(resourceName: "flame-machine-shot4").cgImage!,
            #imageLiteral(resourceName: "flame-machine-shot5").cgImage!,
            #imageLiteral(resourceName: "flame-machine-shot6").cgImage!,
        ]
        shootAnimation.duration = 0.7
        shootAnimation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
        
        gunAnimation.values = [
            #imageLiteral(resourceName: "flame-machine-2").cgImage!,
            #imageLiteral(resourceName: "flame-machine-3").cgImage!,
            #imageLiteral(resourceName: "flame-machine-2").cgImage!,
            #imageLiteral(resourceName: "flame-machine-3").cgImage!
            
        ]
        gunAnimation.keyTimes = [0, 0.35, 0.75, 1]
        gunAnimation.duration = 0.7
        
        lifeDemage = 0.35
        
        hitEffectsIndex = 7
        
        setupGun()
    }
}



// MARK: - Bazooka
class BazookaType: BaseWeaponType {
    
    required init() {
        super.init()
        name = "Bazooka"
        classType = Bazooka.self
        demage = 80
        image = #imageLiteral(resourceName: "bazooka-profile")
        requiredKillsForFree = 1000
    }
}
class Bazooka: BaseWeapon {
    
    required init(gunLayer: CALayer, shootLayer: CALayer) {
        super.init(gunLayer: gunLayer, shootLayer: shootLayer)
        
        gunImage = #imageLiteral(resourceName: "bazooka-1").cgImage
        
        soundName = "bazooka-sound"
        
        shootAnimation.values = [
            #imageLiteral(resourceName: "bazooka-shoot1").cgImage!,
            #imageLiteral(resourceName: "bazooka-shoot2").cgImage!,
            #imageLiteral(resourceName: "bazooka-shoot3").cgImage!,
            #imageLiteral(resourceName: "bazooka-shoot4").cgImage!,
            #imageLiteral(resourceName: "bazooka-shoot5").cgImage!,
        ]
        shootAnimation.duration = 0.3
        shootAnimation.keyTimes = [0, 0.3, 0.5, 0.8, 1]
        
        gunAnimation.values = [
            #imageLiteral(resourceName: "bazooka-2").cgImage!,
            #imageLiteral(resourceName: "bazooka-3").cgImage!
        ]
        
        lifeDemage = 0.8
        
        hitEffectsIndex = 9
        
        setupGun()
    }
}



// MARK: - FG42
class FG42Type: BaseWeaponType {
    
    required init() {
        super.init()
        name = "FG 42"
        classType = FG42.self
        demage = 55
        image = #imageLiteral(resourceName: "fg42-profile")
        requiredKillsForFree = 300
    }
}
class FG42: BaseWeapon {
    
    required init(gunLayer: CALayer, shootLayer: CALayer) {
        super.init(gunLayer: gunLayer, shootLayer: shootLayer)
        
        gunImage = #imageLiteral(resourceName: "fg42-1").cgImage
        
        soundName = "fg42-sound"
        
        shootAnimation.values = [
            #imageLiteral(resourceName: "machine-gun-shot1").cgImage!,
            #imageLiteral(resourceName: "machine-gun-shot2").cgImage!,
            #imageLiteral(resourceName: "machine-gun-shot3").cgImage!,
            #imageLiteral(resourceName: "machine-gun-shot4").cgImage!,
            #imageLiteral(resourceName: "machine-gun-shot5").cgImage!,
            #imageLiteral(resourceName: "machine-gun-shot6").cgImage!,
            #imageLiteral(resourceName: "machine-gun-shot7").cgImage!,
            #imageLiteral(resourceName: "machine-gun-shot8").cgImage!,
        ]
        shootAnimation.duration = 1
        shootAnimation.keyTimes = [0, 0.2, 0.3, 0.5, 0.6, 0.75, 0.9, 1]
        
        gunAnimation.values = [
            #imageLiteral(resourceName: "fg42-2").cgImage!,
            #imageLiteral(resourceName: "fg42-3").cgImage!,
            #imageLiteral(resourceName: "fg42-2").cgImage!,
            #imageLiteral(resourceName: "fg42-3").cgImage!,
            #imageLiteral(resourceName: "fg42-2").cgImage!,
            #imageLiteral(resourceName: "fg42-3").cgImage!,
        ]
        gunAnimation.duration = 1
        gunAnimation.keyTimes = [0, 0.2, 0.4, 0.6 , 0.8, 1]
        
        lifeDemage = 0.55
        
        hitEffectsIndex = 6
        
        setupGun()
    }
}



// MARK: - P99
class P99Type: BaseWeaponType {
    
    required init() {
        super.init()
        name = "Walther P99"
        classType = P99.self
        demage = 10
        image = #imageLiteral(resourceName: "p99-profile")
    }
}
class P99: BaseWeapon {
    
    required init(gunLayer: CALayer, shootLayer: CALayer) {
        super.init(gunLayer: gunLayer, shootLayer: shootLayer)
        
        gunImage = #imageLiteral(resourceName: "p99-1").cgImage
        
        soundName = "p99-sound"
        
        shootAnimation.values = [
            #imageLiteral(resourceName: "nambu-shot").cgImage!
        ]
        shootAnimation.duration = 0.4
        shootAnimation.keyTimes = [1]
        
        gunAnimation.values = [
            #imageLiteral(resourceName: "p99-2").cgImage!,
            #imageLiteral(resourceName: "p99-3").cgImage!
        ]
        
        lifeDemage = 0.1
        
        setupGun()
    }
}


// MARK: - Nambu
class NambuType: BaseWeaponType {
    
    required init() {
        super.init()
        name = "Nambu 1925"
        classType = Nambu.self
        demage = 5
        image = #imageLiteral(resourceName: "nambu-profile")
    }
}
class Nambu: BaseWeapon {
    
    required init(gunLayer: CALayer, shootLayer: CALayer) {
        super.init(gunLayer: gunLayer, shootLayer: shootLayer)
        
        gunImage = #imageLiteral(resourceName: "nambu-1").cgImage
        
        soundName = "nambu-sound"
        
        shootAnimation.values = [
            #imageLiteral(resourceName: "nambu-shot").cgImage!
        ]
        shootAnimation.duration = 0.3
        shootAnimation.keyTimes = [1]
        
        gunAnimation.values = [
            #imageLiteral(resourceName: "nambu-2").cgImage!,
            #imageLiteral(resourceName: "nambu-3").cgImage!
        ]
        
        lifeDemage = 0.05
        
        hitEffectsIndex = 2
        
        setupGun()
    }
}


// MARK: - XPR50
class XPR50Type: BaseWeaponType {
    
    required init() {
        super.init()
        name = "XPR 50"
        classType = XPR50.self
        demage = 30
        image = #imageLiteral(resourceName: "rifle-xpr50-profile")
        requiredKillsForFree = 100
    }
}
class XPR50: BaseWeapon {
    
    required init(gunLayer: CALayer, shootLayer: CALayer) {
        super.init(gunLayer: gunLayer, shootLayer: shootLayer)
        
        gunImage = #imageLiteral(resourceName: "rifle-xpr50-1").cgImage
        
        soundName = "XPR50-sound"
        
        // shootAnimation.values = [insert here ...]
        
        gunAnimation.values = [
            #imageLiteral(resourceName: "rifle-xpr50-2").cgImage!,
            #imageLiteral(resourceName: "rifle-xpr50-3").cgImage!,
            
        ]
        lifeDemage = 0.3
        
        hitEffectsIndex = 5
        
        setupGun()
    }
}



// MARK: - BaseWeapon
class BaseWeaponType {
    
    var name = "Some Weapon"
    
    var classType: BaseWeapon.Type?
    
    var demage: Int?
    
    var image: UIImage?
    
    var requiredKillsForFree = 0
    
    required init() {}
}
class BaseWeapon {
    
    var lifeDemage: Float = 0.05
    
    /// overide z child class
    var gunImage: CGImage?
    
    var audioPlayer: AVAudioPlayer?
    
    var soundName: String?
    
    /// pripraveny na 5 obrazkov
    var shootAnimation = CAKeyframeAnimation(keyPath: "contents")
    
    /// pripraveny na 2 obrazky
    var gunAnimation = CAKeyframeAnimation(keyPath: "contents")
    
    let gunLayer: CALayer
    
    let shootLayer: CALayer
    
    /// cim vacsie cislo tym vacsia pravdepodobnost efektu po zasahu
    var hitEffectsIndex = 3
    
    required init(gunLayer: CALayer, shootLayer: CALayer) {
        self.gunLayer = gunLayer
        self.shootLayer = shootLayer
        
        setupShootAnimation()
        setupGunAnimation()
        
    }
    
    func setupGun() {
        gunLayer.contents = gunImage
    }
    
    private func setupShootAnimation() {
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
        audioPlayer = try? AVAudioPlayer(data: NSDataAsset(name: soundName!)!.data, fileTypeHint: AVFileTypeCoreAudioFormat)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }
}


