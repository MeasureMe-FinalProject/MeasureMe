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
                VStack {
                    Image(.headerLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 45)
                    
                    Spacer()
                    
                    Image(.photoProcessVector)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.all, 40)
                    
                    Text("We're Preparing Your Result")
                        .font(.system(.title3, weight: .semibold))
                        .padding(.bottom, 5)
                    
                    Text("Don't leave this screen until the processing has been completed")
                        .font(.system(.subheadline))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 35)
                        .padding(.bottom)
                    
                    ProgressView()
                    
                    Spacer()
                }
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
    PhotoProcessView(isCapturingComplete: .constant(true), capturedImages: .constant([.frontPreview1, .sidePreview1]))
}

