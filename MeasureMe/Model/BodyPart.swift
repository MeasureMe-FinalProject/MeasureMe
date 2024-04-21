//
//  BodyPart.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/04/24.
//

import SwiftUI

struct BodyPart: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
    let length: String
}

extension BodyPart {
    static let upperBodyParts: [BodyPart] =  [
        BodyPart(name: "Waist", color: .yellow, length: "50 cm"),
        BodyPart(name: "Bust", color: .green, length: "23 cm"),
        BodyPart(name: "Arm", color: .red, length: "44 cm"),
        BodyPart(name: "Shoulder", color: .blue, length: "36 cm")
    ]
    
    static let lowerBodyParts: [BodyPart] =  [
        BodyPart(name: "Hip", color: .yellow, length: "60 cm"),
        BodyPart(name: "Inseam", color: .blue, length: "64 cm"),
    ]
    
    static let generalBodypart: [BodyPart] = [
        BodyPart(name: "Height", color: .yellow, length: "165 cm"),
    ]
}
