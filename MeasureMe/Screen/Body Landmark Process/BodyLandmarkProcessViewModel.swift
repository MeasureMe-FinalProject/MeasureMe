//
//  BodyLandmarkProcessViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 25/04/24.
//

import SwiftUI

final class BodyLandmarkProcessViewModel: ObservableObject {
    @Published var measurementResult: MeasurementResult?
    @Published var isShowMeasurementResultView: Bool = false
    
    let front: Front
    let side: Side
    
    init(front: Front, side: Side) {
        self.front = front
        self.side = side
    }
    
    func uploadAdjustedBodyLandmark(of user: User, height: Int, gender: GenderType, clothingType: ClothingType) {
        NetworkManager.shared.uploadAdjustedBodylandmark(of: user, front: front, side: side, height: height, gender: gender, clothingType: clothingType) { measurementResult in
            guard let measurementResult else { return }
            
            DispatchQueue.main.async {
                self.measurementResult = measurementResult
                
//                // After get the measurementResult then save it to backend
                NetworkManager.shared.saveMeasurementResult(measurementResult)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                self.isShowMeasurementResultView = true
            }
        }
    }
    
    func getLastMeasurementResults(of user: User, measurementResults: Binding<[MeasurementResult]?>) {
        NetworkManager.shared.getRecentMeasurementResults(of: user) { updatedMeasurementResults, _ in
            guard let updatedMeasurementResults else { return }
            DispatchQueue.main.async {
                measurementResults.wrappedValue = updatedMeasurementResults
            }
        }
    }
}
