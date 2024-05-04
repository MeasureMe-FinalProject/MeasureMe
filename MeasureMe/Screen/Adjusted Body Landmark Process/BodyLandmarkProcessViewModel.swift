//
//  BodyLandmarkProcessViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 25/04/24.
//

import Foundation

final class BodyLandmarkProcessViewModel: ObservableObject {
    @Published var measurementResultResponse: MeasurementResultResponse?
    @Published var isShowMeasurementResultView: Bool = false
    
    let front: Front
    let side: Side
    
    init(front: Front, side: Side) {
        self.front = front
        self.side = side
    }
    
    func uploadAdjustedBodyLandmark(height: Int, gender: String, clothingType: String) {
        NetworkManager.shared.uploadAdjustedBodylandmark(front: front, side: side, height: height, gender: gender, clothingType: clothingType) { response in
            guard let response else { return }
            
            DispatchQueue.main.async {
                self.measurementResultResponse = response
                print(self.measurementResultResponse?.sizeRecommendation ?? "Yas dadddy")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isShowMeasurementResultView = true
            }
        }
    }
}
