//
//  ViewController.swift
//  livegun
//
//  Created by Marek Mako on 14/01/2017.
//  Copyright © 2017 Marek Mako. All rights reserved.
//

import UIKit
import AVFoundation

class TestViewController: UIViewController {
    
    var videocnt: Int = 0
    
    fileprivate let avSession = AVCaptureSession()
    fileprivate var videoOutputConnection: AVCaptureConnection?
    fileprivate var videoLayerConnection: AVCaptureConnection?
    
    var videoLayer: AVCaptureVideoPreviewLayer!
    
    let faceLayer = CALayer()
    let leftEyeLayer = CALayer()
    let rightEyeLayer = CALayer()
    let mouthLayer = CALayer()
    
    let aimLayer = CALayer()
    let shootLayer = CALayer()
    let bloodLayer = CALayer()
    let gunLayer = CALayer()
    
    var hitEffects: HitEffects!

    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var processedImageView: UIImageView!

    var weapon: BaseWeapon?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weapon = XPR50(gunLayer: gunLayer, shootLayer: shootLayer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onShot(sender:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func onShot(sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: videoView)
        if touchPoint.x >= videoView.bounds.width - gunLayer.bounds.width && touchPoint.y >= videoView.bounds.height - gunLayer.bounds.height { // klika na zbran
    
            weapon?.onShoot()
            
            // MARK: ZASAH
            let aimLayerCenter = CGPoint(x: aimLayer.bounds.width / 2 + aimLayer.frame.origin.x, y: aimLayer.bounds.height / 2 + aimLayer.frame.origin.y)
            
            if faceLayer.frame.origin.x <= aimLayerCenter.x && (faceLayer.frame.origin.x + faceLayer.bounds.width) >= aimLayerCenter.x &&
                faceLayer.frame.origin.y <= aimLayerCenter.y && faceLayer.frame.origin.y + faceLayer.bounds.height >= aimLayerCenter.y  {

                hitEffects.onHit()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        avSessionSetup()
        startCameraLivePreview()
        hitEffects = HitEffects(videoLayer: videoLayer,
                                faceLayer: faceLayer,
                                laveOkoLayer: leftEyeLayer,
                                praveOkoLayer: rightEyeLayer,
                                ustaLayer: mouthLayer)
    }
    
    fileprivate func currentOrientation() -> AVCaptureVideoOrientation {
        switch UIDevice.current.orientation {
        case .portrait:
            return .portrait
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        videoOutputConnection?.videoOrientation = currentOrientation()
        videoLayerConnection?.videoOrientation = currentOrientation()
    }
}

fileprivate extension TestViewController {
    
    func avSessionSetup() {
        let camera = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera,
                                                   mediaType: AVMediaTypeVideo,
                                                   position: .back)
        
        avSession.beginConfiguration()
        
        // MARK: INPUT VIDEO
        let input = try! AVCaptureDeviceInput(device: camera)
        avSession.addInput(input)
        // najrychlejsi format videa
        var bestFormat: AVCaptureDeviceFormat?
        var bestFrameRange: AVFrameRateRange?
        for format in input.device.formats as! [AVCaptureDeviceFormat] {
            for range in format.videoSupportedFrameRateRanges as! [AVFrameRateRange] {
                if bestFrameRange == nil {
                    bestFrameRange = range
                    bestFormat = format
                    
                } else if bestFrameRange!.maxFrameRate < range.maxFrameRate {
                    bestFrameRange = range
                    bestFormat = format
                }
            }
        }
        #if DEBUG
            print(bestFormat!, bestFrameRange!)
        #endif
        if bestFormat != nil {
            try! input.device.lockForConfiguration()
            
            input.device.activeFormat = bestFormat!
            input.device.activeVideoMinFrameDuration = bestFrameRange!.minFrameDuration
            input.device.activeVideoMaxFrameDuration = bestFrameRange!.minFrameDuration
            input.device.unlockForConfiguration()
        }
        
        
        // MARK: OUTPUT VIDEO
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable : kCMPixelFormat_32BGRA]
        output.alwaysDiscardsLateVideoFrames = true
        
        let queue = DispatchQueue(label: "com.marekmako.livegun.videooutput_queue")
        output.setSampleBufferDelegate(self, queue: queue)
        avSession.addOutput(output)
        
        avSession.commitConfiguration()
        
        // MARK: VIDEO ORIENTATION
        videoOutputConnection = output.connections.first as? AVCaptureConnection
        videoOutputConnection?.videoOrientation = currentOrientation()
    }
    
    func startCameraLivePreview() {
        videoLayer = AVCaptureVideoPreviewLayer(session: avSession)!
        videoLayerConnection = videoLayer.connection
        
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoLayerConnection?.videoOrientation = currentOrientation()
        
        videoLayer.frame = videoView.bounds
        
        videoView.layer.addSublayer(videoLayer)
        avSession.startRunning()
        
        
        // MARK: AIM LAYER
        let aimImage = #imageLiteral(resourceName: "aim").cgImage
        let aimSize = CGSize(width: videoView.bounds.height * 0.3, height: videoView.bounds.height * 0.3)
        aimLayer.frame = CGRect(x: videoView.frame.midX - aimSize.width / 2,
                                y: videoView.layer.frame.midY - aimSize.height,
                                width: aimSize.width,
                                height: aimSize.height)
        aimLayer.contents = aimImage
        videoView.layer.addSublayer(aimLayer)
        
        
        // MARK: SHOOT LAYER
        shootLayer.frame = aimLayer.frame
        videoView.layer.addSublayer(shootLayer)
        
        
        // MARK: BLOOD LAYER
        bloodLayer.frame = aimLayer.frame
        videoView.layer.addSublayer(bloodLayer)
        
        
        // MARK: GUN LAYER
        let gunSize = CGSize(width: videoView.bounds.height * 0.7, height: videoView.bounds.height * 0.7)
        gunLayer.frame = CGRect(x: videoView.frame.maxX - gunSize.width,
                                y: videoView.frame.maxY - gunSize.height,
                                width: gunSize.width,
                                height: gunSize.height)
        gunLayer.contentsGravity = kCAGravityResizeAspect
        videoView.layer.addSublayer(gunLayer)
        
        // MARK: FACE LAYER
        #if DEBUG
            faceLayer.borderWidth = 1
            faceLayer.borderColor = UIColor.red.cgColor
        #endif
        videoView.layer.addSublayer(faceLayer)
        
        
        // MARK: LEFT EYE LAYER
        #if DEBUG
            leftEyeLayer.borderWidth = 1
            leftEyeLayer.borderColor = UIColor.green.cgColor
        #endif
        videoView.layer.addSublayer(leftEyeLayer)
        
        
        // MARK: RIGHT EYE LAYER
        #if DEBUG
            rightEyeLayer.borderWidth = 1
            rightEyeLayer.borderColor = UIColor.blue.cgColor
        #endif
        videoView.layer.addSublayer(rightEyeLayer)
        
        
        // MARK: MOUTH LAYER
        #if DEBUG
            mouthLayer.borderWidth = 1
            mouthLayer.borderColor = UIColor.yellow.cgColor
        #endif
        videoView.layer.addSublayer(mouthLayer)
    }
}

// MARK: AVCaptureVideoDataOutputSampleBufferDelegates
extension TestViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
//        #if DEBUG
//            videocnt += 1
//            print("captureOutput", videocnt, Date())
//        #endif

        guard let cvImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            #if DEBUG
                fatalError()
            #else
                return
            #endif
        }
        let ciImage = CIImage(cvImageBuffer: cvImageBuffer)
        faceDetection(from: ciImage)
    }
    
    fileprivate func faceDetection(from image: CIImage) {
        let options: [String : Any] = [CIDetectorAccuracy : CIDetectorAccuracyLow /*, CIDetectorTracking : true*/]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!
        let faces = detector.features(in: image) as! [CIFaceFeature]
        
        if faces.isEmpty {
            DispatchQueue.main.async {
                self.faceLayer.frame = CGRect(x: self.faceLayer.frame.origin.x,
                                                y: self.faceLayer.frame.origin.y,
                                                width: 0,
                                                height: 0)
                self.leftEyeLayer.frame = CGRect(x: self.leftEyeLayer.frame.origin.x,
                                                 y: self.leftEyeLayer.frame.origin.y,
                                                 width: 0,
                                                 height: 0)
                self.rightEyeLayer.frame = CGRect(x: self.rightEyeLayer.frame.origin.x,
                                                  y: self.rightEyeLayer.frame.origin.y,
                                                  width: 0,
                                                  height: 0)
                self.mouthLayer.frame = CGRect(x: self.mouthLayer.frame.origin.x,
                                               y: self.mouthLayer.frame.origin.y,
                                               width: 0,
                                               height: 0)
                
                self.hitEffects.hideFrames()
            }
        }
        
        for face in faces {

            DispatchQueue.main.async {
                
                // MARK: FRAME PRE TVAR
                let faceFrame = self.createFrame(for: face, from: image, to: self.videoView)
                /// + 30% navrchu
                let headFrame = CGRect(x: faceFrame.minX,
                                       y: faceFrame.minY - faceFrame.height * 0.3,
                                       width: faceFrame.width,
                                       height: faceFrame.height * 1.3)
                self.faceLayer.frame = headFrame
                
                if face.hasLeftEyePosition {
                    self.leftEyeLayer.frame = self.createFrame(for: face.leftEyePosition, from: image, to: self.videoView)
                    
                } else {
                    self.leftEyeLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                }
                
                
                if face.hasRightEyePosition {
                    self.rightEyeLayer.frame = self.createFrame(for: face.rightEyePosition, from: image, to: self.videoView)
                    
                } else {
                    self.rightEyeLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                }
                
                
                if face.hasMouthPosition {
                    self.mouthLayer.frame = self.createFrame(for: face.mouthPosition, from: image, to: self.videoView)
                    
                } else {
                    self.mouthLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                }
                
                self.hitEffects.updateFrames()
            }
        }
    }
    
    private func createFrame(for face: CIFaceFeature, from image: CIImage, to view: UIView) -> CGRect {
        // For converting the Core Image Coordinates to UIView Coordinates
        let ciImageSize = image.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        // Apply the transform to convert the coordinates
        var faceFrame = face.bounds.applying(transform)
        
        // Calculate the actual position and size of the rectangle in the image view
        let viewSize = view.bounds.size
        let scale = min(viewSize.width / ciImageSize.width,
                        viewSize.height / ciImageSize.height)
        let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
        let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
        
        faceFrame = faceFrame.applying(CGAffineTransform(scaleX: scale, y: scale))
        faceFrame.origin.x += offsetX
        faceFrame.origin.y += offsetY
        
        return faceFrame
    }
    
    private func createFrame(for part: CGPoint, from image: CIImage, to view: UIView) -> CGRect {
        // For converting the Core Image Coordinates to UIView Coordinates
        let ciImageSize = image.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        var partFrame = CGRect(x: part.x, y: part.y, width: 10, height: 10).applying(transform)
        
        // Calculate the actual position and size of the rectangle in the image view
        let viewSize = view.bounds.size
        let scale = min(viewSize.width / ciImageSize.width,
                        viewSize.height / ciImageSize.height)
        let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
        let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
        
        partFrame = partFrame.applying(CGAffineTransform(scaleX: scale, y: scale))
        partFrame.origin.x += offsetX
        partFrame.origin.y += offsetY
        
        return partFrame
    }
}

// MARK: FACE EFFECTS

fileprivate extension TestViewController {
    
    func addKrvaveFrkance() {
        let layer = CALayer()
        layer.contents = #imageLiteral(resourceName: "FE-krvave-frkance").cgImage
        layer.contentsGravity = kCAGravityResizeAspect
        
        
        
        layer.backgroundColor = UIColor.red.cgColor
    }
}

