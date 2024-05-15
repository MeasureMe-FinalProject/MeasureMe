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
    let measurementResultResponse: MeasurementResultResponse

    init(measurementResultResponse: MeasurementResultResponse) {
        let waist = measurementResultResponse.measurementResult.waistCircumference
        let bust = measurementResultResponse.measurementResult.bustCircumference
        let arm = measurementResultResponse.measurementResult.sleeveLength
        let shoulder = measurementResultResponse.measurementResult.shoulderWidth
        let hip = measurementResultResponse.measurementResult.hipCircumference
        let inseam = measurementResultResponse.measurementResult.pantsLength
        let sizeRecommendation = measurementResultResponse.sizeRecommendation

        self.measurementDetail = MeasurementDetail(name: "All Body Part",
                                                  icon: "general-body-icon",
                                                  image: "general-body",
                                                  bodyParts: BodyPart.generateAllBodyParts(waist: waist, bust: bust, arm: arm, shoulder: shoulder, hip: hip, inseam: inseam))
                
        self.sizeRecommendation = sizeRecommendation
        self.measurementResultResponse = measurementResultResponse
    }
    
    private let date: Date = Date()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "HH:mm - dd-MM-YYYY"
        return formatter
    }()
    
    var formattedDate: String {
        dateFormatter.string(from: date)
    }
    
    func saveMeasurementResult(of user: User, with clothingType: ClothingType) {
        NetworkManager.shared.saveMeasurementResult(measurementResultResponse, of: user, with: clothingType) { response in
            guard let response else { return }
            print(response)
        }
    }
}
