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
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 450)
                    .padding(.all, 30)
                
                Text("\(viewModel.captureTimeRemaining)")
                    .font(.system(size: 120, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .opacity(viewModel.captureTimeRemaining == 3 ? 0 : 1)
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
        .statusBar(hidden: true)
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
    }
}

#Preview {
    PhotoCaptureView(isShow: .constant(true))
}

struct AngleIndicatorBar: View {
    
    @ObservedObject var viewModel: PhotoCaptureViewModel
    var barGradientColor : RadialGradient {
        RadialGradient(colors: [.red, .green],
                       center: .center,
                       startRadius: 36,
                       endRadius: 22)
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(barGradientColor)
            .frame(width: 24, height: 216)
            .overlay {
                ZStack {
                    VStack(spacing: 20) {
                        ForEach(0..<9) {_ in
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.white)
                                .frame(width: 16, height: 1.5)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "arrowtriangle.right.fill")
                            .foregroundStyle(viewModel.isOnPosition ? .green : .red)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.primary)
                            .frame(width: 18, height: 2)
                        
                        Image(systemName: "arrowtriangle.left.fill")
                            .foregroundStyle(viewModel.isOnPosition ? .green : .red)
                        
                    }
                    .offset(y: viewModel.yPositionIndicator)
                }
            }
            .offset(x: viewModel.isOnPosition ? 150 : 0)
    }
}