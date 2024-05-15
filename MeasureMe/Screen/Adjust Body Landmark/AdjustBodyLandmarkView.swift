//
//  AdjustBodyLandmarkView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 15/02/24.
//

import SwiftUI
import AVFoundation

struct AdjustBodyLandmarkView: View {
    
    @ObservedObject var viewModel: AdjustBodyLandmarkViewModel
    
    var body: some View {
        VStack {
            HStack {
                ForEach(ImageType.allCases, id: \.self) { imageType in
                    Button {
//                        withAnimation {
                            viewModel.changeImageState(imageType: imageType)
//                        }
                    } label: {
                        VStack {
                            Image(systemName: imageType.icon)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22, height: 22)
                                .padding(.horizontal)
                            
                            Text(imageType.name)
                                .font(.footnote)
                                .fontWeight(.medium)
                        }
                        .foregroundStyle(imageType.name == viewModel.currentImage.name ? .blue : .secondary)
                    }
                    
                    if imageType == .frontImage {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: 2)
                    }
                }
            }
            .zIndex(1)
            .padding(.horizontal, 75)
            
            ZStack {
                Color.primary.opacity(0.8)
                
                Image(uiImage: viewModel.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .getCurrentCGRect(from: viewModel.image, in: $viewModel.containerImage)
                    .overlay {
                        ZStack {
                            switch viewModel.currentImage {
                            case .frontImage:
                                createLineBetweenLandmarks(of: viewModel.frontBodyLandmarks)
                                createDraggableLandmarks(of: viewModel.frontBodyLandmarks)
                            case .sideImage:
                                createLineBetweenLandmarks(of: viewModel.sideBodyLandmarks)
                                createDraggableLandmarks(of: viewModel.sideBodyLandmarks)
                            }
                        }
                    }
                    .scaleEffect(viewModel.currentZoom + viewModel.totalZoom)
                    .offset(viewModel.totalOffset)
                    .gesture(viewModel.gestures)
                    .animation(.easeIn, value: viewModel.image)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            
            HStack(alignment: .bottom) {
                Button {
                    viewModel.helpButtonTapped()
                } label: {
                    createButton(icon: "questionmark.app.fill",
                                 title: "Help")
                }
                
                Button {
                    viewModel.recenterButtonTapped()
                } label: {
                    createButton(icon: "rectangle.inset.filled",
                                 title: "Recenter")
                }
                
                Button {
                    viewModel.confirmButtonTapped()
                } label: {
                    createButton(icon: viewModel.currentImage == .sideImage ? "checkmark.square.fill" : "arrow.forward.square.fill",
                                 title: viewModel.currentImage == .sideImage ? "Confirm" : "Next")
                }
            }
            .foregroundStyle(Color.primary.opacity(0.8))
            .padding([.horizontal])
        }
        .overlay {
            if viewModel.isShowHelpPopup {
                showHelpAdjustBodyLandmark()
            }
        }
        .animation(.easeInOut, value: viewModel.isShowHelpPopup)
        .onAppear {
            viewModel.loadBlurredFaceImage(fromURLString: viewModel.bodyLandmarkResponse.frontPath)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.convertBodyLandmarkCoordinates()
                    viewModel.isShowHelpPopup = true
            }
        }
        .fullScreenCover(isPresented: $viewModel.isShowBodyLandmarkProcessView) {
            if let front = viewModel.frontBodyLandmarksObject,
               let side = viewModel.sideBodyLandmarksObject {
                BodyLandmarkProcessView(viewModel: BodyLandmarkProcessViewModel(front: front, side: side))
            }
        }
    }
    
    @ViewBuilder private func createDraggableLandmarks(of bodyLandmarks: [BodyLandmark]) -> some View {
        ForEach(bodyLandmarks) { bodyLandmark in
            DraggableLandmark(bodyLandmark: bodyLandmark, onChanged: viewModel.handleOnChanged)
                .position(bodyLandmark.coordinate)
        }
    }
    
    @ViewBuilder private func createLineBetweenLandmarks(of bodyLandmarks: [BodyLandmark]) -> some View {
        ForEach(viewModel.landmarkLines, id: \.0) { line in
            if let startLandmark = bodyLandmarks.first(where: { $0.landmark == line.start}),
               let endLandmark = bodyLandmarks.first(where: { $0.landmark == line.end }) {
                Path { path in
                    path.move(to: startLandmark.coordinate)
                    path.addLine(to: endLandmark.coordinate)
                }
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [7.5]))
                .fill(.white)
            }
        }
    }
    
    @ViewBuilder private func showHelpAdjustBodyLandmark() -> some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.background)
                    .overlay(alignment: .bottom) {
                        ZStack(alignment: .topTrailing) {
                            Button {
                                withAnimation {
                                    viewModel.isShowHelpPopup.toggle()
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(.headline, weight: .semibold))
                                    .foregroundStyle(.foreground)
                            }
                            .padding()
                            VStack {
                                Text("How to use editor")
                                    .font(.system(.title2, weight: .bold))
                                    .padding(.top)
                                
                                HStack {
                                    ForEach(0..<3) { index in
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill( index == viewModel.currentHelpPageIndex ? .blue : .gray )
                                            .frame(width: 15, height: 3)
                                    }
                                }
                                
                                TabView(selection: $viewModel.currentHelpPageIndex) {
                                    ForEach(viewModel.helpAdjustBodyLandmarkPages.indices, id: \.self) { index in
                                        createHelpAdjustBodyLandmarkPage(page: viewModel.helpAdjustBodyLandmarkPages[index])
                                            .tag(viewModel.helpAdjustBodyLandmarkPages[index])
                                    }
                                }
                                .tabViewStyle(.page(indexDisplayMode: .never))
                                
                                Button {
                                    viewModel.moveToNextHelpPage()
                                } label: {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 53)
                                        .overlay {
                                            Text(viewModel.isLastPage ? "Done" : "Next")
                                                .font(.system(.headline))
                                                .foregroundStyle(.white)
                                        }
                                }
                            }
                            .padding()
                        }
                    }

                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .fill(.white.opacity(0.4))
            }
            .frame(width: 300, height: 500)
        }
    }
    
    @ViewBuilder private func createHelpAdjustBodyLandmarkPage(page: HelpAdjustBodyLandmarkPage) -> some View {
        VStack {
            Image(page.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            
            Text(page.title)
                .font(.system(.headline))
                .foregroundStyle(.primary)
                .padding(.bottom, 5)
            
            Text(page.description)
                .font(.system(.caption))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom)
        }
    }
    
    @ViewBuilder private func createButton(icon: String, title: String) -> some View {
        VStack(spacing: 10){
            Image(systemName: icon)
                .imageScale(.large)
            Text(title)
                .font(.caption)
        }
        .frame(width: 55, height: 50)
        .padding(.horizontal, 25)
    }
}

#Preview {
    AdjustBodyLandmarkView(viewModel: AdjustBodyLandmarkViewModel(bodyLandmarkResponse: BodyLandmarkResponse.dummyBodyLandmarkResponse, capturedImages: [UIImage(resource: .frontPreview1), UIImage(resource: .sidePreview1)]))
}

struct SizeCalculator: ViewModifier {
    
    let image: UIImage
    @Binding var size: CGRect
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                size = proxy.frame(in: .local)
                            }
                        }
                        .onChange(of: image) {
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                size = proxy.frame(in: .local)
                            }
                        }
                }
            )
    }
}
