//
//  PhotoCaptureViewController.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 27/02/24.
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate {
    func didCapture(image: UIImage)
}

class CameraViewController: UIViewController {
    
    let camera: Camera = Camera()
    var previewLayer: AVCaptureVideoPreviewLayer?
    var delegate: CameraViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        startPhotoCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        stopPhotoCaptureSession()
    }
        
    func takePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        camera.photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    private func startPhotoCaptureSession() {
        previewLayer = AVCaptureVideoPreviewLayer(session: camera.captureSession)
        camera.checkCameraPermission()

        guard let previewLayer else { return }
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(previewLayer)
    }
    
    private func stopPhotoCaptureSession() {
        camera.stopCaptureSession()
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        
        delegate?.didCapture(image: image)
    }
}
