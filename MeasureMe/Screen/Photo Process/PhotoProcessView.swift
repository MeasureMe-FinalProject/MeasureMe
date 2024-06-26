//
//  PhotoProcessView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 28/02/24.
//

import SwiftUI

struct PhotoProcessView: View {
        
    @StateObject var viewModel: PhotoProcessViewModel = PhotoProcessViewModel()
    @Binding var isCapturingComplete: Bool
    @Binding var capturedImages: [UIImage]
    
    var body: some View {
        ZStack {
            if viewModel.isShowUndetectedBodyView {
                UndetectedBodyView(isCapturingComplete: $isCapturingComplete, capturedImages: $capturedImages)
            } else {
                ProcessStateView()
            }
        }
        .onAppear { viewModel.uploadCapturedImages(capturedImages) }
        .fullScreenCover(isPresented: $viewModel.isShowAdjustBodyLandmarkView) {
            AdjustBodyLandmarkView(viewModel: AdjustBodyLandmarkViewModel(bodyLandmarkResponse: viewModel.bodyLandmarkResponse!, capturedImages: capturedImages))
        }
    }
    
    func didDismiss() {
        isCapturingComplete.toggle()
    }
}

#Preview {
    PhotoProcessView(isCapturingComplete: .constant(true), 
                     capturedImages: .constant([UIImage(resource: .frontTest),
                                                UIImage(resource: .sideTest)]))
        .environmentObject(SharedProfileData(gender: .male, clothingType: .shortPants, user: .dummyUser))
}

