//
//  MeasurementDetail.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/04/24.
//

import Foundation

struct MeasurementDetail: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let image: String
    let bodyParts: [BodyPart]
}
