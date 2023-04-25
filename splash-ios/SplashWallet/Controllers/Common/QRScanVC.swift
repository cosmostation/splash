//
//  QRScanViewController.swift
//  Cosmostation
//
//  Created by yongjoo on 02/05/2019.
//  Copyright © 2019 wannabit. All rights reserved.
//

import UIKit
import AVFoundation

class QRScanVC: BaseVC {
    
    var scanDelegate: ScanDelegate?
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var scanGuide: UIImageView!
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession.startRunning()
            
            view.bringSubviewToFront(scanGuide)
            view.bringSubviewToFront(btnCancel)
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            print(error)
            let permissionAlert = UIAlertController(title: NSLocalizedString("error_access_camera_title", comment: ""),
                                                    message: NSLocalizedString("error_access_camera_msg", comment: ""),
                                                    preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .default, handler: nil)
            let settingAction = UIAlertAction(title: NSLocalizedString("setting", comment: ""), style: .default) { (action) in
                guard let appSettingURl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(appSettingURl) {
                    UIApplication.shared.open(appSettingURl, options: [:], completionHandler: nil)
                }
            }
            permissionAlert.addAction(cancelAction)
            permissionAlert.addAction(settingAction)
            present(permissionAlert, animated: true, completion: nil)
            return
        }
    }
    
    override func setLocalizedString() {
        navigationItem.title = NSLocalizedString("vc_title_scan_qr", comment: "")
        btnCancel.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
    }

    @IBAction func onClickCancel(_ sender: UIButton) {
        if let navigationController = self.navigationController {
            navigationController.view.layer.add(moveoutAni(), forKey: kCATransition)
            navigationController.popViewController(animated: false)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    func getAddress(address: String) {
        if presentedViewController != nil {
            return
        }
        if (self.navigationController != nil) {
            let transition:CATransition = CATransition()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.reveal
            transition.subtype = CATransitionSubtype.fromBottom
            
            self.scanDelegate?.onScanned(address)
            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.popViewController(animated: false)
            
        } else {
            dismiss(animated: true) {
                self.scanDelegate?.onScanned(address)
            }
            
        }
    }
}

extension QRScanVC: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds

            if metadataObj.stringValue != nil {
                getAddress(address: metadataObj.stringValue!)
            }
        }
    }
}

protocol ScanDelegate{
    func onScanned(_ result: String)
}

