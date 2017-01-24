//
//  FaceEffects.swift
//  livegun
//
//  Created by Marek Mako on 22/01/2017.
//  Copyright © 2017 Marek Mako. All rights reserved.
//

import UIKit
import AVFoundation


class HitEffects {
    /// hlavny layer pouziva sa na krvave frkance
    private let videoLayer: CALayer!
    
    /// vyuziva sa na efekty na tvari
    private let faceLayer: CALayer!
    
    private let laveOkoLayer: CALayer!
    
    private let praveOkoLayer: CALayer!
    
    private let ustaLayer: CALayer!

    private var krvaveFrkanceCollection = [KrvaveFrkance]()
    
    private var availableEffects: [BaseHitEffect.Type] = [
        Sekera.self,
        ModrinaLaveOko.self,
        ModrinaPraveOko.self,
        UstaKrv.self,
        KrvaveStrelyCelo.self,
        RezPraveOko.self,
        OhenNaHlave.self,
        VidlickaDoBrady.self,
        PilaDoCela.self
    ]
    
    private var effectsInUse = [BaseHitEffect]()
    
    init(videoLayer: CALayer, faceLayer: CALayer, laveOkoLayer: CALayer, praveOkoLayer: CALayer, ustaLayer: CALayer) {
        self.videoLayer = videoLayer
        self.faceLayer = faceLayer
        self.laveOkoLayer = laveOkoLayer
        self.praveOkoLayer = praveOkoLayer
        self.ustaLayer = ustaLayer
    }
    
    func onHit() {
        krvaveFrkanceCollection.append(KrvaveFrkance(parent: videoLayer))
        
        guard arc4random_uniform(10) < 3 else {
            return
        }
        
        guard !availableEffects.isEmpty else {
            return
        }
        let effectIndex = Int(arc4random_uniform(UInt32(availableEffects.count)))
        let effectType = availableEffects.remove(at: effectIndex)
        
        switch effectType {
        case is Sekera.Type, is KrvaveStrelyCelo.Type, is OhenNaHlave.Type, is PilaDoCela.Type:
            effectsInUse.append(effectType.init(parent: faceLayer))
            break
        case is ModrinaLaveOko.Type:
            effectsInUse.append((effectType as! ModrinaLaveOko.Type).init(parent: videoLayer, face: faceLayer, laveOko: laveOkoLayer))
            break
        case is ModrinaPraveOko.Type:
            effectsInUse.append((effectType as! ModrinaPraveOko.Type).init(parent: videoLayer, face: faceLayer, praveOko: praveOkoLayer))
            break
        case is RezPraveOko.Type:
            effectsInUse.append((effectType as! RezPraveOko.Type).init(parent: videoLayer, face: faceLayer, praveOko: praveOkoLayer))
            break
        case is UstaKrv.Type:
            effectsInUse.append((effectType as! UstaKrv.Type).init(parent: videoLayer, face: faceLayer, usta: ustaLayer))
            break
        case is VidlickaDoBrady.Type:
            effectsInUse.append((effectType as! VidlickaDoBrady.Type).init(parent: videoLayer, face: faceLayer, usta: ustaLayer))
            break
        default:
            #if DEBUG
                fatalError()
            #else
                return
            #endif
        }
    }
    
    func updateFrames() {
        for effect in effectsInUse {
            effect.updateLayerFrameAgainsParent()
        }
    }
    
    func hideFrames() {
        for effect in effectsInUse {
            effect.hideLayerFrame()
        }
    }
    
    func hideRandKrvaveFrkance() {
        let cnt = Int(arc4random_uniform(UInt32(krvaveFrkanceCollection.count)))
        for i in 0..<cnt {
            krvaveFrkanceCollection[i].layer.removeFromSuperlayer()
        }
        krvaveFrkanceCollection.removeFirst(cnt)
    }
}

fileprivate class BaseHitEffect {
    
    var audioPlayer: AVAudioPlayer?
    
    let layer = CALayer()
    
    let parentLayer: CALayer!
    
    var soundData: NSDataAsset?
    
    required init(parent parentLayer: CALayer) {
        layer.contentsGravity = kCAGravityResizeAspect
        
        self.parentLayer = parentLayer
        self.parentLayer.addSublayer(layer)
    }
    
    func updateLayerFrameAgainsParent() {}
    
    func hideLayerFrame() {}
    
    fileprivate func playSound() {
        guard soundData != nil else {
            return
        }
        try? audioPlayer = AVAudioPlayer(data: soundData!.data, fileTypeHint: AVFileTypeCoreAudioFormat)
        audioPlayer?.play()
    }
}

fileprivate class KrvaveFrkance : BaseHitEffect {
    
    let scaleAgainstParent = CGFloat(arc4random_uniform(6)) / 10
    
    required init(parent parentLayer: CALayer) {
        super.init(parent: parentLayer)
        
        layer.contents = #imageLiteral(resourceName: "FE-krvave-frkance").cgImage
        soundData = NSDataAsset(name: "FE-krvave-frkance-sound")
        
        updateLayerFrameAgainsParent()
        playSound()
    }
    
    override func updateLayerFrameAgainsParent() {
        let size = CGSize(width: parentLayer.bounds.width * scaleAgainstParent,
                          height: parentLayer.bounds.height * scaleAgainstParent)
        
        let maxX = parentLayer.frame.maxX - size.width
        let maxY = parentLayer.frame.maxY - size.height
        let randX = CGFloat(arc4random_uniform(UInt32(maxX < 0 ? 0 : maxX)))
        let randY = CGFloat(arc4random_uniform(UInt32(maxY < 0 ? 0 : maxY)))
        
        layer.frame = CGRect(x: randX, y: randY, width: size.width, height: size.height)
    }
}

fileprivate class Sekera: BaseHitEffect {
    
    let scaleAgainstParent: CGFloat = 1
    
    required init(parent parentLayer: CALayer) {
        super.init(parent: parentLayer)
        
        layer.contents = #imageLiteral(resourceName: "FE-sekera").cgImage
        soundData = NSDataAsset(name: "FE-sekera-sound")

        updateLayerFrameAgainsParent()
        playSound()
    }
    
    override func updateLayerFrameAgainsParent() {
        let size = CGSize(width: parentLayer.bounds.width * scaleAgainstParent,
                          height: parentLayer.bounds.height * scaleAgainstParent)
        
        layer.frame = CGRect(x: -(size.width / 2), y: -(size.height / 2), width: size.width, height: size.height)
    }
    
    override func hideLayerFrame() {
        layer.frame = CGRect(x: layer.frame.minX, y: layer.frame.minY, width: 0, height: 0)
    }
}

fileprivate class PilaDoCela: BaseHitEffect {
    
    let scaleAgainstParent: CGFloat = 1
    
    required init(parent parentLayer: CALayer) {
        super.init(parent: parentLayer)
        
        layer.contents = #imageLiteral(resourceName: "FE-pila-do-cela").cgImage
        soundData = NSDataAsset(name: "FE-pila-do-cela-sound")
        
        updateLayerFrameAgainsParent()
        playSound()
    }
    
    override func updateLayerFrameAgainsParent() {
        let size = CGSize(width: parentLayer.bounds.width * scaleAgainstParent,
                          height: parentLayer.bounds.height * scaleAgainstParent)
        
        layer.frame = CGRect(x: parentLayer.bounds.width / 2, y: -(size.height / 4), width: size.width, height: size.height)
    }
    
    override func hideLayerFrame() {
        layer.frame = CGRect(x: layer.frame.minX, y: layer.frame.minY, width: 0, height: 0)
    }
}

fileprivate class OhenNaHlave: BaseHitEffect {
    
    let scaleAgainstParent: CGFloat = 0.8
    
    required init(parent parentLayer: CALayer) {
        super.init(parent: parentLayer)
        
        layer.contents = #imageLiteral(resourceName: "FE-ohen-na-hlave").cgImage
        soundData = NSDataAsset(name: "FE-ohen-na-hlave-sound")
        
        updateLayerFrameAgainsParent()
        playSound()
    }
    
    override func updateLayerFrameAgainsParent() {
        let size = CGSize(width: parentLayer.bounds.width * scaleAgainstParent,
                          height: parentLayer.bounds.height * scaleAgainstParent)
        
        layer.frame = CGRect(x: parentLayer.bounds.width / 2 - size.width / 2, y: -size.height / 3 * 2, width: size.width, height: size.height)
    }
    
    override func hideLayerFrame() {
        layer.frame = CGRect(x: layer.frame.minX, y: layer.frame.minY, width: 0, height: 0)
    }
}

fileprivate class KrvaveStrelyCelo: BaseHitEffect {
    
    let scaleAgainstParent: CGFloat = 0.8
    
    required init(parent parentLayer: CALayer) {
        super.init(parent: parentLayer)
        
        layer.contents = #imageLiteral(resourceName: "FE-krvave-strely-celo").cgImage
        soundData = NSDataAsset(name: "FE-krvave-strely-celo-sound")
        
        updateLayerFrameAgainsParent()
        playSound()
    }
    
    override func updateLayerFrameAgainsParent() {
        let size = CGSize(width: parentLayer.bounds.width * scaleAgainstParent,
                          height: parentLayer.bounds.height * scaleAgainstParent)
        
        layer.frame = CGRect(x: size.width / 5, y: -(size.height / 5), width: size.width, height: size.height)
    }
    
    override func hideLayerFrame() {
        layer.frame = CGRect(x: layer.frame.minX, y: layer.frame.minY, width: 0, height: 0)
    }
}

fileprivate class ModrinaLaveOko: BaseHitEffect {
    
    let scaleAgainstParent: CGFloat = 0.2
    
    var faceLayer: CALayer!
    var okoLayer: CALayer!
    
    required convenience init(parent parentLayer: CALayer, face faceLayer: CALayer!, laveOko okoLayer: CALayer) {
        self.init(parent: parentLayer)
        self.faceLayer = faceLayer
        self.okoLayer = okoLayer
        updateLayerFrameAgainsParent()
    }
    
    required init(parent parentLayer: CALayer) {
        super.init(parent: parentLayer)
        
        layer.contents = #imageLiteral(resourceName: "FE-modrina-lave-oko").cgImage
        soundData = NSDataAsset(name: "FE-modrina-lave-oko-sound")
        
        playSound()
    }
    
    fileprivate override func updateLayerFrameAgainsParent() {
        let size = CGSize(width: faceLayer.bounds.width * scaleAgainstParent, height: faceLayer.bounds.height * scaleAgainstParent)
        
        layer.frame = CGRect(x: okoLayer.frame.minX - size.width / 2,
                             y: okoLayer.frame.maxY/* - size.height / 5*/,
                             width: size.width,
                             height: size.height)
    }
    
    fileprivate override func hideLayerFrame() {
        layer.frame = CGRect(x: layer.frame.minX, y: layer.frame.minY, width: 0, height: 0)
    }
}

fileprivate class ModrinaPraveOko: BaseHitEffect {
    
    let scaleAgainstParent: CGFloat = 0.2
    
    var faceLayer: CALayer!
    var okoLayer: CALayer!
    
    required convenience init(parent parentLayer: CALayer, face faceLayer: CALayer!, praveOko okoLayer: CALayer) {
        self.init(parent: parentLayer)
        self.faceLayer = faceLayer
        self.okoLayer = okoLayer
        updateLayerFrameAgainsParent()
    }
    
    required init(parent parentLayer: CALayer) {
        super.init(parent: parentLayer)
        
        layer.contents = #imageLiteral(resourceName: "FE-modrina1-prave-oko").cgImage
        soundData = NSDataAsset(name: "FE-modrina1-prave-oko-sound")
        
        playSound()
    }
    
    fileprivate override func updateLayerFrameAgainsParent() {
        let size = CGSize(width: faceLayer.bounds.width * scaleAgainstParent, height: faceLayer.bounds.height * scaleAgainstParent)
        
        layer.frame = CGRect(x: okoLayer.frame.minX - size.width / 2,
                             y: okoLayer.frame.maxY,
                             width: size.width,
                             height: size.height)
    }
    
    fileprivate override func hideLayerFrame() {
        layer.frame = CGRect(x: layer.frame.minX, y: layer.frame.minY, width: 0, height: 0)
    }
}

fileprivate class RezPraveOko: BaseHitEffect {
    
    let scaleAgainstParent: CGFloat = 0.4
    
    var faceLayer: CALayer!
    var okoLayer: CALayer!
    
    required convenience init(parent parentLayer: CALayer, face faceLayer: CALayer!, praveOko okoLayer: CALayer) {
        self.init(parent: parentLayer)
        self.faceLayer = faceLayer
        self.okoLayer = okoLayer
        updateLayerFrameAgainsParent()
    }
    
    required init(parent parentLayer: CALayer) {
        super.init(parent: parentLayer)
        
        layer.contents = #imageLiteral(resourceName: "FE-krvavy-rez-prave-oko").cgImage
        soundData = NSDataAsset(name: "FE-krvavy-rez-prave-oko-sound")
        
        playSound()
    }
    
    fileprivate override func updateLayerFrameAgainsParent() {
        let size = CGSize(width: faceLayer.bounds.width * scaleAgainstParent, height: faceLayer.bounds.height * scaleAgainstParent)
        
        layer.frame = CGRect(x: okoLayer.frame.minX - size.width / 2,
                             y: okoLayer.frame.maxY,
                             width: size.width,
                             height: size.height)
    }
    
    fileprivate override func hideLayerFrame() {
        layer.frame = CGRect(x: layer.frame.minX, y: layer.frame.minY, width: 0, height: 0)
    }
}


fileprivate class UstaKrv: BaseHitEffect {
    
    let scaleAgainstParent: CGFloat = 0.6
    
    var faceLayer: CALayer!
    var ustaLayer: CALayer!
    
    required convenience init(parent parentLayer: CALayer, face faceLayer: CALayer!, usta ustaLayer: CALayer) {
        self.init(parent: parentLayer)
        self.faceLayer = faceLayer
        self.ustaLayer = ustaLayer
        updateLayerFrameAgainsParent()
    }
    
    required init(parent parentLayer: CALayer) {
        super.init(parent: parentLayer)
        
        layer.contents = #imageLiteral(resourceName: "FE-usta-krv").cgImage
        
        soundData = NSDataAsset(name: "FE-usta-krv-sound")
        
        playSound()
    }
    
    fileprivate override func updateLayerFrameAgainsParent() {
        let size = CGSize(width: faceLayer.bounds.width * scaleAgainstParent, height: faceLayer.bounds.height * scaleAgainstParent)
        
        layer.frame = CGRect(x: ustaLayer.frame.minX - size.width / 2,
                             y: ustaLayer.frame.maxY - size.height / 5,
                             width: size.width,
                             height: size.height)
    }
    
    fileprivate override func hideLayerFrame() {
        layer.frame = CGRect(x: layer.frame.minX, y: layer.frame.minY, width: 0, height: 0)
    }
}

fileprivate class VidlickaDoBrady: BaseHitEffect {
    
    let scaleAgainstParent: CGFloat = 0.8
    
    var faceLayer: CALayer!
    var ustaLayer: CALayer!
    
    required convenience init(parent parentLayer: CALayer, face faceLayer: CALayer!, usta ustaLayer: CALayer) {
        self.init(parent: parentLayer)
        self.faceLayer = faceLayer
        self.ustaLayer = ustaLayer
        updateLayerFrameAgainsParent()
    }
    
    required init(parent parentLayer: CALayer) {
        super.init(parent: parentLayer)
        
        layer.contents = #imageLiteral(resourceName: "FE-vidlicka-do-brady").cgImage
        
        soundData = NSDataAsset(name: "FE-vidlicka-do-brady-sound")
        
        playSound()
    }
    
    fileprivate override func updateLayerFrameAgainsParent() {
        let size = CGSize(width: faceLayer.bounds.width * scaleAgainstParent, height: faceLayer.bounds.height * scaleAgainstParent)
        
        layer.frame = CGRect(x: ustaLayer.frame.minX - size.width / 3,
                             y: ustaLayer.frame.maxY,
                             width: size.width,
                             height: size.height)
    }
    
    fileprivate override func hideLayerFrame() {
        layer.frame = CGRect(x: layer.frame.minX, y: layer.frame.minY, width: 0, height: 0)
    }
}

