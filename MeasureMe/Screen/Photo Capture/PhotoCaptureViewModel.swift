//
//  AngleDetectorViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 27/02/24.
//

/**lhttps://developer.apple.com/documentation/coremotion/getting_raw_gyroscope_events#2904021**/

import SwiftUI
import CoreMotion

enum ImageType: CaseIterable {
    case frontImage
    case sideImage
    
    var name: String {
        switch self {
        case .frontImage:
            "Front"
        case .sideImage:
            "Side"
        }
    }
    
    var icon: String {
        switch self {
        case .frontImage:
            "figure.arms.open"
        case .sideImage:
            "figure.walk"
        }
    }
    
    var bodyPoseImage: String {
        switch self {
        case .frontImage:
            "front-body-pose"
        case .sideImage:
            "side-body-pose"
        }
    }
}

struct CapturedImages {
    var frontImage: UIImage
    var sideImage: UIImage
}

final class PhotoCaptureViewModel: ObservableObject {
    @Published var angleDegrees: Double = 0
    @Published var yPositionIndicator: CGFloat = 0
    @Published var isOnPosition: Bool = false
    private let motionManager = CMMotionManager()
    
    @Published var imageType: ImageType = .frontImage
    
    let countdownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var isPreparingComplete: Bool = false
    var prepareTimeRemaining: Int = 2
    @Published var captureTimeRemaining: Int = 10 
    @Published var isCapturePhoto: Bool = false
    @Published var isCapturingPhotoComplete: Bool = false
    @Published var capturedImages: [UIImage] = []

    var screenOverlayGradientColor: RadialGradient {
        RadialGradient(colors: [isOnPosition ? .green : .red, .clear],
                       center: .center,
                       startRadius: 600,
                       endRadius: 200)
    }
    
    func startGyro() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion is not available.")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            
            guard let self = self, let motionData = motion else {
                print("Failed to retrieve motion data.")
                return
            }

            // Get the pitch from quaternion
            let quaternionPitch = self.calculateQuaternionPitch(from: motionData)
            
            // Set the minY and maxY offset of the indicator according to the View's indicator
            self.yPositionIndicator = self.calculateOffset(angleDegrees: quaternionPitch, minAngle: 60, maxAngle: 80, minY: -90, maxY: 90)

            // Check if the user has rotated 67 degrees until 72 degrees
            self.isOnPosition = (67...72).contains(quaternionPitch)
            
            // Check if there's any error
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func stopGyro() {
        motionManager.stopGyroUpdates()
    }
    
    func startCountingdownTimer() {
        guard isOnPosition else { resetCountdownTimer(); return }
        if isPreparingComplete {
            startCaptureCountdown()
        } else {
            startPrepareCountdown()
        }
    }
    
    private func startCapturePhoto() {
        isCapturePhoto = true
        switch imageType {
        case .frontImage:
            imageType = .sideImage
        case .sideImage:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isCapturingPhotoComplete = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                imageType = .frontImage
                resetCountdownTimer()
            }
        }
        captureTimeRemaining = 10
    }
    
    private func startCaptureCountdown() {
        if captureTimeRemaining > 0 {
                captureTimeRemaining -= 1
        } else if captureTimeRemaining == 0 {
            startCapturePhoto()
        }
    }
    
    private func startPrepareCountdown() {
        if prepareTimeRemaining > 0 {
            prepareTimeRemaining -= 1
        } else if prepareTimeRemaining == 0 {
            withAnimation {
                isPreparingComplete = true
            }
        }
    }
    
    private func resetCountdownTimer() {
        withAnimation {
            prepareTimeRemaining = 2
            captureTimeRemaining = 10
            isPreparingComplete = false
        }
    }

    private func calculateQuaternionPitch(from motionData: CMDeviceMotion) -> CGFloat {
        let quat = motionData.attitude.quaternion
        return CGFloat(radiansToDegrees(atan2(2 * (quat.x * quat.w + quat.y * quat.z),
                                              1 - 2 * quat.x * quat.x - 2 * quat.z * quat.z)))
    }

    private func radiansToDegrees(_ radians: Double) -> Double {
        return radians * (180.0 / Double.pi)
    }

    private func calculateOffset(angleDegrees: Double, minAngle: Double, maxAngle: Double, minY: Double, maxY: Double) -> Double {
        // Ensure angle is within the specified range
        let angle = max(min(angleDegrees, maxAngle), minAngle)

        // Calculate the offset
        let offset = ((angle - minAngle) / (maxAngle - minAngle)) * (maxY - minY) + minY

        return offset
    }
}
