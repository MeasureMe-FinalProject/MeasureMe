//
//  Result.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 21/02/24.
//

import Foundation


struct MeasurementResultResponse: Codable {
    let status: String
    let message: String
    let measurementResults: [MeasurementResult]
    
    enum CodingKeys: String, CodingKey {
        case status             = "status"
        case message            = "message"
        case measurementResults = "measurement_result"
    }
}

struct MeasurementResult: Codable, Identifiable, Equatable {
    let id: Int?
    let idUser: Int
    let date: String
    let clothingType: String
    let gender: String
    let sizeRecommendation: String
    let height: Double
    let bustCircumference: Double
    let waistCircumference: Double
    let hipCircumference: Double
    let shoulderWidth: Double
    let sleeveLength: Double
    let pantsLength: Double
    
    
    enum CodingKeys: String, CodingKey {
        case id                 = "id"
        case idUser             = "id_user"
        case date               = "date"
        case clothingType       = "type_clothes"
        case gender             = "gender"
        case sizeRecommendation = "size_recommendation"
        case height             = "height"
        case bustCircumference  = "bust_circumference"
        case waistCircumference = "waist_circumference"
        case hipCircumference   = "hip_circumference"
        case shoulderWidth      = "shoulder_width"
        case sleeveLength       = "sleeve_length"
        case pantsLength        = "pants_length"
        
    }
}

extension MeasurementResult {
    static let dummyRecentMeasurementResult: [MeasurementResult]?  = /*nil*/
    [
        MeasurementResult(id: nil, 
                          idUser: 23,
                          date: "01-02-2023, 20:30",
                          clothingType: "Short Pants",
                          gender: "Male",
                          sizeRecommendation: "S",
                          height: 162,
                          bustCircumference: 40,
                          waistCircumference: 20,
                          hipCircumference: 30,
                          shoulderWidth: 73,
                          sleeveLength: 38,
                          pantsLength: 39),
        
//            MeasurementResult(id: 1,
//                                    idUser: 23,
//                              date: "S",
//                              clothingType: 163,
//                              gender: 160,
//                              sizeRecommendation: 20,
//                              height: 20,
//                              bustCircumference: 30,
//                              waistCircumference: 40,
//                              hipCircumference: 40,
//                              shoulderWidth: "01-02-2023, 20:30",
//                              sleeveLength: "Short Pants"),
//            
//            MeasurementResult(id: 2,
//                                    idUser: 23,
//                                    date: "S",
//                                    clothingType: 165,
//                                    gender: 160,
//                                    sizeRecommendation: 20,
//                                    height: 20,
//                                    bustCircumference: 30,
//                                    waistCircumference: 40,
//                                    hipCircumference: 40,
//                                    shoulderWidth: "17-02-2023, 13:41",
//                                    sleeveLength        : "Long Pants"),
//            
//            MeasurementResult(id: 3,
//                                    idUser: 23,
//                                    sizeRecommendation: "M",
//                                    height: 165,
//                                    bustCircumference: 160,
//                                    waistCircumference: 20,
//                                    hipCircumference: 20,
//                                    shoulderWidth: 30,
//                                    sleeveLength: 40,
//                                    pantsLength: 40,
//                                    date: "8-05-2023, 15:13",
//                                    clothingType: "Jacket"),
//            
//            MeasurementResult(id: 4,
//                                    idUser: 23,
//                                    sizeRecommendation: "M",
//                                    height: 165,
//                                    bustCircumference: 160,
//                                    waistCircumference: 20,
//                                    hipCircumference: 20,
//                                    shoulderWidth: 30,
//                                    sleeveLength: 40,
//                                    pantsLength: 40,
//                                    date: "28-11-2023, 12:13",
//                                    clothingType: "Long Pants"),
//            
//            MeasurementResult(id: 5,
//                                    idUser: 23,
//                                    sizeRecommendation: "M",
//                                    height: 165,
//                                    bustCircumference: 160,
//                                    waistCircumference: 20,
//                                    hipCircumference: 20,
//                                    shoulderWidth: 30,
//                                    sleeveLength: 40,
//                                    pantsLength: 40,
//                                    date: "15-12-2023, 11:49",
//                                    clothingType: "T-Shirt")
            
            ]
}
