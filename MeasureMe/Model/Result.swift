//
//  Result.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 21/02/24.
//

import Foundation


struct RecentMeasurementResultResponse: Codable {
    let status: String
    let message: String
    let measurementResults: [RecentMeasurementResult]
    
    enum CodingKeys: String, CodingKey {
        case status             = "status"
        case message            = "message"
        case measurementResults = "measurement_result"
    }
}

struct RecentMeasurementResult: Codable, Identifiable, Equatable {
    let id: Int
    let idUser: Int
    let sizeRecommendation: String
    let height: Double
    let bustCircumference: Double
    let waistCircumference: Double
    let hipCircumference: Double
    let shoulderWidth: Double
    let sleeveLength: Double
    let pantsLength: Double
    let date: String
    let clothingType: String
    
    enum CodingKeys: String, CodingKey {
        case id                 = "id"
        case idUser             = "id_user"
        case sizeRecommendation = "size_recommendation"
        case height             = "height"
        case bustCircumference  = "bust_circumference"
        case waistCircumference = "waist_circumference"
        case hipCircumference   = "hip_circumference"
        case shoulderWidth      = "shoulder_width"
        case sleeveLength       = "sleeve_length"
        case pantsLength        = "pants_length"
        case date               = "date"
        case clothingType       = "type_clothes"
    }
}

extension RecentMeasurementResult {
    static let dummyRecentMeasurementResult: [RecentMeasurementResult] = [
        
//            RecentMeasurementResult(id: 1,
//                                    idUser: 23,
//                                    sizeRecommendation: "S",
//                                    height: 163,
//                                    bustCircumference: 160,
//                                    waistCircumference: 20,
//                                    hipCircumference: 20,
//                                    shoulderWidth: 30,
//                                    sleeveLength: 40,
//                                    pantsLength: 40,
//                                    date: "01-09-2024, 20:30",
//                                    clothingType: "Short Pants"),
//            
//            RecentMeasurementResult(id: 2,
//                                    idUser: 23,
//                                    sizeRecommendation: "S",
//                                    height: 165,
//                                    bustCircumference: 160,
//                                    waistCircumference: 20,
//                                    hipCircumference: 20,
//                                    shoulderWidth: 30,
//                                    sleeveLength: 40,
//                                    pantsLength: 40,
//                                    date: "17-02-2024, 13:41",
//                                    clothingType: "Long Pants"),
//            
//            RecentMeasurementResult(id: 3,
//                                    idUser: 23,
//                                    sizeRecommendation: "M",
//                                    height: 165,
//                                    bustCircumference: 160,
//                                    waistCircumference: 20,
//                                    hipCircumference: 20,
//                                    shoulderWidth: 30,
//                                    sleeveLength: 40,
//                                    pantsLength: 40,
//                                    date: "8-05-2024, 15:13",
//                                    clothingType: "Jacket")
            
            ]
}
