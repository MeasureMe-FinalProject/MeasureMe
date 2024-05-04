//
//  BodyPart.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/04/24.
//

import SwiftUI

struct BodyPart: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let color: Color
    let length: Double
}

extension BodyPart {
    static let allBodyParts: [BodyPart] = [
        BodyPart(name: "Shoulder", color: .red, length: 36),
        BodyPart(name: "Bust", color: .yellow, length: 50),
        BodyPart(name: "Waist", color: .green, length: 23),
        BodyPart(name: "Hip", color: .blue, length: 43),
        BodyPart(name: "Inseam", color: .indigo, length: 44),
    ]
    
    static func generateAllBodyParts(waist: Double, bust: Double, arm: Double, shoulder: Double, hip: Double, inseam: Double) -> [BodyPart] {
        [
            BodyPart(name: "Shoulder", color: .red, length: shoulder),
            BodyPart(name: "Arm", color: .yellow, length: arm),
            BodyPart(name: "Bust", color: .green, length: bust),
            BodyPart(name: "Waist", color: .blue, length: waist),
            BodyPart(name: "Hip", color: .purple, length: hip),
            BodyPart(name: "Inseam", color: .brown, length: inseam),
        ]
    }
}
