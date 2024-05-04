//
//  MeasurementResult.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 19/04/24.
//

import Foundation

struct MeasurementResultResponse: Codable, Identifiable {
    let id = UUID()
    
    let measurementResult: MeasurementResult
    let sizeRecommendation: String
    
    
    enum CodingKeys: String, CodingKey {
        case measurementResult       = "measurement_result"
        case sizeRecommendation      = "size_recommendation"
        
    }
}

struct MeasurementResult: Codable {
    let height: Double
    let bustCircumference: Double
    let waistCircumference: Double
    let hipCircumference: Double
    let shoulderWidth: Double
    let sleeveLength: Double
    let pantsLength: Double
    
    enum CodingKeys: String, CodingKey {
        case height             = "height"
        case bustCircumference  = "bust_circumference"
        case waistCircumference = "waist_circumference"
        case hipCircumference    = "hip_circumference"
        case shoulderWidth      = "shoulder_width"
        case sleeveLength       = "sleeve_length"
        case pantsLength        = "pants_length"
    }
}

struct SizeRecommendation: Codable {
    let sizeRecommendation: String
    
    enum CodingKeys: String, CodingKey {
        case sizeRecommendation = "size_recommendation"
    }
}

extension MeasurementResultResponse {
    static let dummyMeasurementResultResponse: MeasurementResultResponse = MeasurementResultResponse(measurementResult: MeasurementResult(height: 170,
                                                                                                                                          bustCircumference: 45,
                                                                                                                                          waistCircumference: 25,
                                                                                                                                          hipCircumference: 35,
                                                                                                                                          shoulderWidth: 50,
                                                                                                                                          sleeveLength: 40,
                                                                                                                                          pantsLength: 70),
                                                                                                     sizeRecommendation: "S")
}
