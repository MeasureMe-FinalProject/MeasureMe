//
//  AngleDetectorView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 27/02/24.
//

import SwiftUI

struct PhotoCaptureView: View {
    
    @StateObject var viewModel = PhotoCaptureViewModel()
    @Binding var isShow: Bool
    
    var body: some View {
        ZStack {
            CameraView(isCapturePhoto: $viewModel.isCapturePhoto, 
                       isCapturingPhotoComplete: $viewModel.isCapturingPhotoComplete,
                       capturedImages: $viewModel.capturedImages)
                .ignoresSafeArea()
            
            Rectangle()
                .fill(viewModel.screenOverlayGradientColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.thinMaterial)
                .overlay(alignment: .leading) {
                    VStack(alignment: .leading,spacing: 7.5) {
                        Text("Instruction:")
                            .font(.system(.body, weight: .bold))
                        
                        Text(viewModel.isOnPosition ? "Make sure your device stays in this angle range. The measurement will begin on its own. Don't move your device while it's measuring." : "Place your device leaning against the wall, directed towards your chosen posing area. An indicator will show you the proper angle.")
                            .font(.system(.caption2, weight: .regular))
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                .frame(height: 100)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.horizontal)
            
            
            if viewModel.isPreparingComplete {
                Image(viewModel.imageType.bodyPoseImage)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.white)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 450)
                    .padding(.all, 30)
                
                Text("\(viewModel.captureTimeRemaining)")
                    .font(.system(size: 120, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
//                    .opacity(viewModel.captureTimeRemaining == 3 ? 0 : 1)
                    .opacity(viewModel.isCapturingPhotoComplete ? 0 : 1)
            } else {
                AngleIndicatorBar(viewModel: viewModel)
                
                VStack(spacing: 15) {
                    Image(systemName: viewModel.isOnPosition ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .scaleEffect(2)
                        .foregroundStyle(viewModel.isOnPosition ? .green : .red)
                    
                    Text(viewModel.isOnPosition ? "" : "Please follow the instructions below!")
                        .font(.system(.caption, weight: .semibold))
                }
                .offset(y: viewModel.isOnPosition ? 0 : -300)
            }
        }
        .statusBar(hidden: true)
        .overlay(alignment: .topTrailing) {
            Button {
                viewModel.stopGyro()
                withAnimation {
                    isShow.toggle()
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(.title2, weight: .semibold))
                    .foregroundStyle(.black)
            }
            .padding()
        }
        .onAppear {
            viewModel.isCapturingPhotoComplete ? viewModel.stopGyro() : viewModel.startGyro()
        }
        .onReceive(viewModel.countdownTimer) { _ in
            viewModel.startCountingdownTimer()
        }
        .onChange(of: viewModel.capturedImages) {
            print(viewModel.capturedImages.count)
        }
        .animation(.interpolatingSpring, value: viewModel.isOnPosition)
        .fullScreenCover(isPresented: $viewModel.isCapturingPhotoComplete) {
            PhotoProcessView(isCapturingComplete: $viewModel.isCapturingPhotoComplete, capturedImages: $viewModel.capturedImages)
        }
    }
}

#Preview {
    PhotoCaptureView(isShow: .constant(true))
}

