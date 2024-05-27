//
//  ARViewViewControllerRepresentable.swift
//  BodyTrackingBlueprint
//
//  Created by Diki Dwi Diro on 18/01/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewVCRepresentable: UIViewControllerRepresentable {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ARMeasurementViewModel
        
    func makeUIViewController(context: Context) -> ARSCNViewVC {
        ARSCNViewVC(aRViewVCDelegate: context.coordinator)
    }
    
    // From SwiftUI to UIKit
    func updateUIViewController(_ uiViewController: ARSCNViewVC, context: Context) {
        if viewModel.isPlusButtonTapped {
            DispatchQueue.main.async {
                uiViewController.startMeasuring()
            }
        } else {
            DispatchQueue.main.async {
                uiViewController.stopMeasuring()
            }
        }
        
        if viewModel.isClearButtonTapped {
            DispatchQueue.main.async {
                uiViewController.stopMeasuring()
                uiViewController.clearAllLines(self)
                viewModel.isClearButtonTapped = false
            }
        }
    }
    
    // MARK: - Coordinator
    // From UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator(arViewViewControllerRepresentable: self)
    }
    
    class Coordinator: ARViewVCDelegate {
        private let arViewVCRepresentable: ARViewVCRepresentable
        
        init(arViewViewControllerRepresentable: ARViewVCRepresentable) {
            self.arViewVCRepresentable = arViewViewControllerRepresentable
        }
        
        func didFind(distance: String) {
            arViewVCRepresentable.viewModel.distance = distance
        }
        
        func didCoachingOverlay(enabled : Bool) {
            arViewVCRepresentable.viewModel.isCoachingOverlayEnabled = enabled
        }
        
        func shouldPlusButton(disabled: Bool) {
            arViewVCRepresentable.viewModel.shouldButtonDisabled = disabled
        }
        
        func didShowRecommendation(message: String) {
            arViewVCRepresentable.viewModel.recommendationString = message
        }
    }
}
