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
            Image(.headerLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 45)
                .padding([.horizontal, .bottom])
            
            ZStack {
                Color.primary.opacity(0.8)
                
                #warning("You may create an object that holds the captured images and the coordinates")
                Image(uiImage: viewModel.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .getCurrentCGRect(from: viewModel.image, in: $viewModel.containerImage)
                    .overlay {
                        ZStack {
                            createLineBetweenLandmarks()
                            createDraggableLandmarks()
                        }
                    }
                    .scaleEffect(viewModel.currentZoom + viewModel.totalZoom)
                    .offset(viewModel.totalOffset)
                    .gesture(viewModel.gestures)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 15))
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
                    createButton(icon: "checkmark.square.fill",
                                 title: "Confirm")
                }
            }
            .foregroundStyle(Color.primary.opacity(0.8))
            .padding([.horizontal, .top])
        }
        .blur(radius: viewModel.isShowHelpPopup ? 3 : 0)
        .overlay {
            if viewModel.isShowHelpPopup {
                showHelpAdjustBodyLandmark()
            }
        }
        .onAppear {
            viewModel.loadBlurredFaceImage(of: .frontImage, fromURLString: viewModel.bodyLandmarkResponse.frontPath)
        }
    }
    
    @ViewBuilder private func createDraggableLandmarks() -> some View {
        ForEach(viewModel.bodyLandmarks) { bodyLandmark in
            DraggableLandmark(bodyLandmark: bodyLandmark, onChanged: viewModel.handleOnChanged)
                .position(bodyLandmark.coordinate)
        }
    }
    
    @ViewBuilder private func createLineBetweenLandmarks() -> some View {
        ForEach(viewModel.landmarkLines, id: \.0) { line in
            if let startLandmark = viewModel.bodyLandmarks.first(where: { $0.landmark == line.start}),
               let endLandmark = viewModel.bodyLandmarks.first(where: { $0.landmark == line.end }) {
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
            Color.black.opacity(0.3)
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
    AdjustBodyLandmarkView(viewModel: AdjustBodyLandmarkViewModel(bodyLandmarkResponse: BodyLandmarkResponse.dummyBodyLandmarkResponse, capturedImages: [.frontPreview1, .sidePreview1]))
}

struct DraggableLandmark: View {
    
    let bodyLandmark: BodyLandmark
    var onChanged: ((CGSize, BodyLandmark) -> Void)?
    @State private var dragAmount: CGSize = .zero
    private var isTopBodyLandmark: Bool { bodyLandmark.landmark == .top }
    private var isBottomBodyLandmark: Bool { bodyLandmark.landmark == .bot }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { newValue in
                dragAmount = newValue.translation
                onChanged?(dragAmount, bodyLandmark)
            }
            .onEnded { _ in
                withAnimation {
                    onChanged?(dragAmount, bodyLandmark)
                    dragAmount = .zero
                }
            }
    }
    
    var body: some View {
        ZStack {
            Text(bodyLandmark.landmark.name)
                .font(.system(.caption2, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 5)
                .padding(.vertical, 2.5)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.blue)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 1.5).fill(.white)
                        }
                }
                .opacity(isTopBodyLandmark || isBottomBodyLandmark ? 1 : 0)
                .offset(y: isTopBodyLandmark ? -15 : isBottomBodyLandmark ? 15 : 0)
            
            Circle()
                .fill(.blue)
                .frame(width: 10, height: 10)
        }
        .offset(dragAmount)
        .gesture(dragGesture)
    }
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
