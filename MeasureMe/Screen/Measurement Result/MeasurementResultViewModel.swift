//
//  MeasurementResultViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/04/24.
//

import SwiftUI

final class MeasurementResultViewModel: ObservableObject {
    
    @Published var settingsDetent = PresentationDetent.medium
    @Published var measurementResultImage: Image?
    @Published var isShowMeasurementDetailView: Bool = false
    
    let measurementDetail: MeasurementDetail
    let sizeRecommendation: String
    let measurementResult: MeasurementResult
    
    var measurementResultIcon: String {
        switch measurementResult.clothingType {
        case "T-Shirt":
            "👕"
        case "Long Pants":
            "👖"
        case "Jacket":
            "🧥"
        case "Short Pants":
            "🩳"
        default:
            ""
        }
    }

    init(measurementResult: MeasurementResult) {
        let waist = measurementResult.waistCircumference
        let bust = measurementResult.bustCircumference
        let arm = measurementResult.sleeveLength
        let shoulder = measurementResult.shoulderWidth
        let hip = measurementResult.hipCircumference
        let inseam = measurementResult.pantsLength
        let sizeRecommendation = measurementResult.sizeRecommendation
        self.measurementDetail = MeasurementDetail(name: "All Body Part",
                                                  icon: "general-body-icon",
                                                  image: "general-body",
                                                  bodyParts: BodyPart.generateAllBodyParts(waist: waist, bust: bust, arm: arm, shoulder: shoulder, hip: hip, inseam: inseam))
                
        self.sizeRecommendation = sizeRecommendation
        self.measurementResult = measurementResult
    }
    
    func updateMeasurementResults(measurementResults: Binding<[MeasurementResult]?>, of user: User) {
        NetworkManager.shared.getRecentMeasurementResults(of: user) { updatedMeasurementResults, _ in
            guard let updatedMeasurementResults else { return }
            DispatchQueue.main.async {
                measurementResults.wrappedValue = updatedMeasurementResults
            }
        }
    }
    
    func doneButtonTapped(dismiss: DismissAction, isMeasurementFinished: Binding<Bool>) {
        isMeasurementFinished.wrappedValue = false
        dismiss()
    }
}
