//
//  SharedProfileData.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 22/04/24.
//

import Foundation

final class SharedProfileData: ObservableObject {
    @Published var height: Int = 166
    @Published var gender: GenderType?
    @Published var clothingType: ClothingType?
    
    @Published var isMeasurementFinished: Bool = false
    
    @Published var user: User
    @Published var measurementResults: [RecentMeasurementResult]?
    
    init(gender: GenderType? = nil, clothingType: ClothingType? = nil, user: User, measurementResults: [RecentMeasurementResult]? = nil) {
        self.gender = gender
        self.clothingType = clothingType
        self.user = user
        self.measurementResults = measurementResults
    }
}
