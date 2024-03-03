//
//  AdjustBodyLandmarkViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 17/02/24.
//

import SwiftUI
import AVFoundation

final class AdjustBodyLandmarkViewModel: ObservableObject {
    
    // MARK: - Body Landmarks properties
    @Published var bodyLandmarks: [BodyLandmark] = []
    @Published var currentImage: ImageType = .frontImage
    @Published var image: UIImage
    @Published var containerImage: CGRect = .zero
    var bodyLandmarkResponse: BodyLandmarkResponse
    let landmarkLines: [(start: BodyLandmarkType, end: BodyLandmarkType)] = [
        (.top, .bot),
        (.shoulderLeft, .shoulderRight),
        (.sleeveTop, .sleeveBot),
        (.waistStart, .waistEnd),
        (.bustLeft, .bustRight),
        (.hipLeft, .hipRight),
        (.pantsTop, .pantsBot),
    ]
    
    // MARK: - Magnify gesture properties
    @Published var currentZoom = 0.0
    @Published var totalZoom = 1.3
    
    // MARK: - Drag gesture prope
    @Published var initialPosition: CGPoint = .zero
    @Published var totalOffset: CGSize = .zero
    
    // MARK: - Help Adjust Body Landmark properties
    @Published var isShowHelpPopup: Bool = false
    @Published var currentHelpPageIndex: Int = 0
    var isLastPage: Bool {
        currentHelpPageIndex >= 2
    }
    let helpAdjustBodyLandmarkPages: [HelpAdjustBodyLandmarkPage] = [
        HelpAdjustBodyLandmarkPage(title: HelpAdjustBodyLandmarkContent.pageOne.title,
                                   description: HelpAdjustBodyLandmarkContent.pageOne.description,
                                   image: HelpAdjustBodyLandmarkContent.pageOne.image),
        
        HelpAdjustBodyLandmarkPage(title: HelpAdjustBodyLandmarkContent.pageTwo.title,
                                   description: HelpAdjustBodyLandmarkContent.pageTwo.description,
                                   image: HelpAdjustBodyLandmarkContent.pageTwo.image),
        
        HelpAdjustBodyLandmarkPage(title: HelpAdjustBodyLandmarkContent.pageThree.title,
                                   description: HelpAdjustBodyLandmarkContent.pageThree.description,
                                   image: HelpAdjustBodyLandmarkContent.pageThree.image)
    ]
    
    // MARK: - Other properties
    var gestures: some Gesture {
        DragGesture()
            .onChanged { [self] newValue in
                withAnimation {
                    if initialPosition == .zero {
                        initialPosition = newValue.location
                    }
                    
                    let translation = CGSize(width: newValue.location.x - initialPosition.x,
                                             height: newValue.location.y - initialPosition.y)
                    
                    totalOffset.width += translation.width
                    totalOffset.height += translation.height
                    initialPosition = newValue.location
                }
            }
            .onEnded { [self] _ in
                initialPosition = .zero
            }
            .exclusively(before: MagnifyGesture()
                .onChanged { [self] value in
                    withAnimation {
                        currentZoom = value.magnification - 1
                    }
                }
                .onEnded { [self] value in
                    totalZoom = totalZoom + currentZoom
                    currentZoom = 0
                    
                    withAnimation {
                        if totalZoom < 1.3 {
                           totalZoom = 1.3
                            
                        } else if totalZoom > 5 {
                           totalZoom = 5
                        }
                    }
                }
            )
    }
    
    enum ImageType {
        case frontImage
        case sideImage
    }
    
    // MARK: - Initialization
    
    init(bodyLandmarkResponse: BodyLandmarkResponse, capturedImages: [UIImage]) {
        self.bodyLandmarkResponse = bodyLandmarkResponse
        self.image = capturedImages.first ?? .placeholderAdjustLandmark
    }
    
    // MARK: - Public functions
    
    func loadBlurredFaceImage(of imageType: ImageType, fromURLString urlString: String) {
        NetworkManager.shared.loadBlurredImages(fromURLString: urlString) { image in
            guard let image else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                self?.convertBodyLandmarkCoordinates(of: imageType)
            }
        }
    }
    
    func convertBodyLandmarkCoordinates(of imageType: ImageType) {
//        guard let image else { return }
        
        switch imageType {
        case .frontImage:
            bodyLandmarks = bodyLandmarkResponse.front.allBodyLandmarks.map { bodyLandmark in
                let convertedCoordinates = convertCoordinate(bodyLandmark.coordinate, of: image, to: containerImage)
                return BodyLandmark(landmark: bodyLandmark.landmark, coordinate: convertedCoordinates)
            }
        case .sideImage:
            bodyLandmarks = bodyLandmarkResponse.side.allBodyLandmarks.map { bodyLandmark in
                let convertedCoordinates = convertCoordinate(bodyLandmark.coordinate, of: image, to: containerImage)
                return BodyLandmark(landmark: bodyLandmark.landmark, coordinate: convertedCoordinates)
            }
        }
        
    }
    
    func handleOnChanged(draggedValue: CGSize, of bodyLandmark: BodyLandmark) {
        if let index = bodyLandmarks.firstIndex(where: { $0.id == bodyLandmark.id }) {
            bodyLandmarks[index].coordinate.x += draggedValue.width
            bodyLandmarks[index].coordinate.y += draggedValue.height
        }
    }
    
    func moveToNextHelpPage() {
        withAnimation {
            if isLastPage {
                isShowHelpPopup = false
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.currentHelpPageIndex = 0
                }
            } else {
                currentHelpPageIndex += 1
            }
        }
        
    }
    
    func helpButtonTapped() {
        withAnimation {
            isShowHelpPopup = true
        }
    }
    
    func recenterButtonTapped() {
        withAnimation {
            totalOffset = .zero
            totalZoom = 1.3
        }
    }
    
    func confirmButtonTapped() {
        loadBlurredFaceImage(of: .sideImage, fromURLString: bodyLandmarkResponse.sidePath)
    }
}

// MARK: - Private functions
extension AdjustBodyLandmarkViewModel {
    private func convertCoordinate(_ coordinate: CGPoint, of sourceImage: UIImage, to containerImage: CGRect) -> CGPoint {
        let imageRect = contentClippingRect(for: sourceImage, in: containerImage)
        let scale = scale(for: sourceImage, in: containerImage)
        
        let screenCoordinate: CGPoint = CGPoint (
            x: (coordinate.x / scale) + imageRect.origin.x,
            y: (coordinate.y / scale) + imageRect.origin.y
        )
        
        return screenCoordinate
    }
    
    private func convertCoordinate(_ coordinate: CGPoint, of containerImage: CGRect, to sourceImage: UIImage) -> CGPoint {
        let imageRect = contentClippingRect(for: sourceImage, in: containerImage)
        let scale = scale(for: sourceImage, in: containerImage)
        
        let imageCoordinate: CGPoint = CGPoint(
            x: (coordinate.x  - imageRect.origin.x) * scale,
            y: (coordinate.y - imageRect.origin.y) * scale
        )
        
        return imageCoordinate
    }
    
    private func scale(for sourceImage: UIImage, in containerImage: CGRect) -> CGFloat {
        let scale = (
            x: sourceImage.size.width / containerImage.width,
            y: sourceImage.size.height / containerImage.height
        )
        return scale.x > scale.y ? scale.x : scale.y
    }
    
    private func contentClippingRect(for sourceImage: UIImage, in containerImage: CGRect) -> CGRect {
        return AVMakeRect(aspectRatio: sourceImage.size, insideRect: containerImage)
    }
}
