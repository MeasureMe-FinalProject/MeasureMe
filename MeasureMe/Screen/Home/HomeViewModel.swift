//
//  HomeViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 21/02/24.
//

import UIKit

enum ClothingType: CaseIterable, Codable {
    case tShirt
    case LongPants
    case jacket
    case shortPants
    
    var name: String {
        switch self {
        case .tShirt:
            "T-Shirt"
        case .LongPants:
            "Long Pants"
        case .jacket:
            "Jacket"
        case .shortPants:
            "Short Pants"
        }
    }
    
    var icon: String {
        switch self {
        case .tShirt:
            "👕"
        case .LongPants:
            "👖"
        case .jacket:
            "🧥"
        case .shortPants:
            "🩳"
        }
    }
    
    var codeName: String {
        switch self {
        case .tShirt:
            "T_SHIRT"
        case .LongPants:
            "LONG_PANTS"
        case .jacket:
            "JACKET"
        case .shortPants:
            "SHORT_PANTS"
        }
    }
}


final class HomeViewModel: ObservableObject {
    @Published var fullName: String = "Diki"
    @Published var isShowNewMeasurementView: Bool = false
    
    let dummyRecentResults: [Result] = [
        Result(name: "Body Measurement", icon: "📐", date: .now),
        Result(name: "Size Recommendation", icon: "👕", date: .now),
        Result(name: "Size Recommendation", icon: "👖", date: .now)
    ]
}
