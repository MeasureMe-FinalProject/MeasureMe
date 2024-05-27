//
//  AdjustedBodyLandmark.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 19/04/24.
//

import Foundation

struct AdjustedBodyLandmarkResponse: Codable {
    let actualHeight: Int
    let gender: String
    let clothingType: String
    let adjustedKeypoints: AdjustedKeypoints
    
    struct AdjustedKeypoints: Codable {
        let front: Front
        let side: Side
    }
    
    enum CodingKeys: String, CodingKey {
        case actualHeight       = "actual_height"
        case gender             = "gender"
        case clothingType       = "clothing_type"
        case adjustedKeypoints  = "adjusted_keypoints"
    }
}
