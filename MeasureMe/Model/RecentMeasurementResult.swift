//
//  RecentMeasurementResult.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 19/04/24.
//

import Foundation

struct RecentMeasurementResultResponse: Codable {
    let measurementResult: RecentMeasurementResult
    let sizeRecommendation: String
    
    enum CodingKeys: String, CodingKey {
        case measurementResult       = "measurement_result"
        case sizeRecommendation      = "size_recommendation"
    }
}

struct RecentMeasurementResult: Codable {
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
