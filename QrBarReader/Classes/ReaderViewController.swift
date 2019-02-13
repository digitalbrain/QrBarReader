//
//  ReaderViewController.swift
//  Pods-QrBarReader_Example
//
//  Created by Massimiliano on 13/02/2019.
//

import UIKit
import AVFoundation

class ReaderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
   
    var session: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var didCaputreCode: ((_ code: String) -> ())?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        session = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Error Creation AVCaptureDevice")
            return
        }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            print("Error Creation AVCaptureDeviceInput")
            return
        }
        if (session.canAddInput(videoInput)) {
            session.addInput(videoInput)
        } else {
            //TODO: - something
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        } else {
            //TODO: - something
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: session);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = .resizeAspectFill;
        view.layer.addSublayer(previewLayer);
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let barcodeData = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if let code = barcodeData.stringValue {
                self.didCaputreCode?(code)
                session.stopRunning()
            }
        }
    }
    
}
