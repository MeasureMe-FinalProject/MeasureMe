//
//  PhotoCaptureView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 27/02/24.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    
    @Binding var isCapturePhoto: Bool
    @Binding var isCapturingPhotoComplete: Bool
    @Binding var capturedImages: [UIImage]
    
    final class Coordinator: NSObject, AVCapturePhotoCaptureDelegate, CameraViewControllerDelegate {
        let cameraView: CameraView
        
        init(_ cameraView: CameraView) {
            self.cameraView = cameraView
        }
        
        func didCapture(image: UIImage) {
            cameraView.capturedImages.append(image)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraViewController = CameraViewController()
        cameraViewController.delegate = context.coordinator
        return cameraViewController
    }
    
    func updateUIViewController(_ cameraViewController: CameraViewController, context: Context) {
        if isCapturePhoto {
            cameraViewController.takePhoto()
            DispatchQueue.main.async {
                self.isCapturePhoto = false
            }
        }
        
        if isCapturingPhotoComplete {
            cameraViewController.camera.stopCaptureSession()
        } else {
            cameraViewController.camera.checkCameraPermission()
        }
    }
}
