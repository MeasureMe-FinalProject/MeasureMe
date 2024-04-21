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
//    @Published var bodyLandmarks: [BodyLandmark] = []
    @Published var frontBodyLandmarks: [BodyLandmark]
    @Published var sideBodyLandmarks: [BodyLandmark]
    @Published var currentImage: ImageType = .frontImage
    @Published var image: UIImage
    @Published var containerImage: CGRect = .zero
    var bodyLandmarkResponse: BodyLandmarkResponse
    let landmarkLines: [(start: BodyLandmarkType, end: BodyLandmarkType)] = [
        (.top, .bot),
        (.shoulderStart, .shoulderEnd),
        (.sleeveTop, .sleeveBot),
        (.waistStart, .waistEnd),
        (.bustStart, .bustEnd),
        (.hipStart, .hipEnd),
        (.pantsTop, .pantsBot),
    ]
    
    // MARK: - Magnify gesture properties
    @Published var currentZoom = 0.0
    @Published var totalZoom = 1.360
    
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
    }
    
    // MARK: - Initialization
    
    init(bodyLandmarkResponse: BodyLandmarkResponse, capturedImages: [UIImage]) {
        self.bodyLandmarkResponse = bodyLandmarkResponse
        self.image = capturedImages.first ?? .placeholderAdjustLandmark
        
        self.frontBodyLandmarks = bodyLandmarkResponse.front.allBodyLandmarks
        self.sideBodyLandmarks = bodyLandmarkResponse.side.allBodyLandmarks
    }
    
    // MARK: - Public functions
    
    func loadBlurredFaceImage(fromURLString urlString: String) {
        NetworkManager.shared.loadBlurredImages(fromURLString: urlString) { image in
            guard let image else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
//                self?.convertBodyLandmarkCoordinates()
            }
        }
    }
    
    func convertBodyLandmarkCoordinates() {        
        frontBodyLandmarks = bodyLandmarkResponse.front.allBodyLandmarks.map { bodyLandmark in
            let convertedCoordinates = convertCoordinate(bodyLandmark.coordinate, of: image, to: containerImage)
            return BodyLandmark(landmark: bodyLandmark.landmark, coordinate: convertedCoordinates)
        }
        sideBodyLandmarks = bodyLandmarkResponse.side.allBodyLandmarks.map { bodyLandmark in
            let convertedCoordinates = convertCoordinate(bodyLandmark.coordinate, of: image, to: containerImage)
            return BodyLandmark(landmark: bodyLandmark.landmark, coordinate: convertedCoordinates)
            
        }
    }
    
    func handleOnChanged(draggedValue: CGSize, of bodyLandmark: BodyLandmark) {
        switch currentImage {
        case .frontImage:
            if let index = frontBodyLandmarks.firstIndex(where: { $0.id == bodyLandmark.id }) {
                frontBodyLandmarks[index].coordinate.x += draggedValue.width
                frontBodyLandmarks[index].coordinate.y += draggedValue.height
            }
        case .sideImage:
            if let index = sideBodyLandmarks.firstIndex(where: { $0.id == bodyLandmark.id }) {
                sideBodyLandmarks[index].coordinate.x += draggedValue.width
                sideBodyLandmarks[index].coordinate.y += draggedValue.height
            }
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
            totalZoom = 1.36
        }
    }
    
    func confirmButtonTapped() {
        switch currentImage {
        case .frontImage:
            currentImage = .sideImage
            loadBlurredFaceImage(fromURLString: bodyLandmarkResponse.sidePath)
        case .sideImage:
//            uploadAdjustedBodylandmarks()
            let frontBodyLandmarks = bodyLandmarkResponse.front.allBodyLandmarks.map { bodyLandmark in
                let convertedCoordinates = convertCoordinate(bodyLandmark.coordinate, of: containerImage, to: image)
                return BodyLandmark(landmark: bodyLandmark.landmark, coordinate: convertedCoordinates)
            }
            let sideBodyLandmarks = bodyLandmarkResponse.side.allBodyLandmarks.map { bodyLandmark in
                let convertedCoordinates = convertCoordinate(bodyLandmark.coordinate, of: containerImage, to: image)
                return BodyLandmark(landmark: bodyLandmark.landmark, coordinate: convertedCoordinates)
                
            }

            guard let front = createFrontObject(from: frontBodyLandmarks) else { return print("front nil")}
            guard let side = createSideObject(from: sideBodyLandmarks) else { return print("side nil")}
                    
            NetworkManager.shared.uploadAdjustedBodylandmark(front: front, side: side, height: 170, gender: "MALE", clothingType: "T_SHIRT") { response in
                guard response != nil else { return }
                print("uploaded")
            }
        }
    }
    
    func changeImageState(imageType: ImageType) {
        switch imageType {
        case .frontImage:
            currentImage = .frontImage
            loadBlurredFaceImage(fromURLString: bodyLandmarkResponse.frontPath)
        case .sideImage:
            currentImage = .sideImage
            loadBlurredFaceImage(fromURLString: bodyLandmarkResponse.sidePath)
        }
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
    
    // Function to convert BodyLandmarks array to Front instance
    private func createFrontObject(from bodyLandmarks: [BodyLandmark]) -> Front? {
//        guard bodyLandmarks.count == 16 else {
//            return nil
//        }
        
        var coordinates: [Coordinate] = []
        for landmark in bodyLandmarks {
            coordinates.append(Coordinate(x: Double(landmark.coordinate.x), y: Double(landmark.coordinate.y)))
        }
        
        return Front(
            shoulderStart: coordinates[0],
            shoulderEnd: coordinates[1],
            sleeveTop: coordinates[2],
            elbow: coordinates[3],
            sleeveBot: coordinates[4],
            waistStart: coordinates[5],
            waistEnd: coordinates[6],
            bustStart: coordinates[7],
            bustEnd: coordinates[8],
            hipStart: coordinates[9],
            hipEnd: coordinates[10],
            pantsTop: coordinates[11],
            knee: coordinates[12],
            pantsBot: coordinates[13],
            top: coordinates[14],
            bot: coordinates[15]
        )
    }
    
    private func createSideObject(from bodyLandmarks: [BodyLandmark]) -> Side? {
//        guard bodyLandmarks.count == 16 else {
//            return nil
//        }
        
        var coordinates: [Coordinate] = []
        for landmark in bodyLandmarks {
            coordinates.append(landmark.coordinate.createCoordinateObject())
        }
        
        return Side(bustStart: coordinates[0],
                    bustEnd: coordinates[1],
                    waistStart: coordinates[2],
                    waistEnd: coordinates[3],
                    hipStart: coordinates[4],
                    hipEnd: coordinates[5],
                    top: coordinates[6],
                    bot: coordinates[7])
    }

    
    private func uploadAdjustedBodylandmarks() {
        
    }
}

extension CGPoint {
    func createCoordinateObject() -> Coordinate {
        Coordinate(x: self.x, y: self.y)
    }
}
