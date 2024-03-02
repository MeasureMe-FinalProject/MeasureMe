//
//  Camera.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 27/02/24.
//

import UIKit
import AVFoundation

class Camera: NSObject, AVCapturePhotoCaptureDelegate {

    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    
    override init() {
        super.init()
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video
                                                               , position: .front) else { return }
        
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(captureDeviceInput)
        
        captureSession.addOutput(photoOutput)
        for connection in photoOutput.connections {
            connection.isVideoMirrored = true
        }
    }
    
    func checkCameraStatus() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] isGranted in
                if isGranted {
                    self?.startCaptureSession()
                } else {
                    print("The app doesn't have a permission to open the camera")
                }
            }
        case .restricted:
            print("The app doesn't have an access to camera due to some restrictions")
        case .denied:
            print("The user has previously denied the access to open the camera")
        case .authorized:
            self.startCaptureSession()
        default:
            print("There is a problem for using the camera. Please check your device")
        }
    }
    
    func stopCaptureSession() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    private func startCaptureSession() {
        DispatchQueue.global().async { [self] in
            captureSession.startRunning()
        }
    }
}
