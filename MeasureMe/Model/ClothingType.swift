//
//  ClothingType.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 13/05/24.
//

import Foundation

enum ClothingType: CaseIterable, Codable, Identifiable {
    var id: Self {

          return self
      }
    
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
