//
//  SharedProfileData.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 22/04/24.
//

import Foundation

final class SharedProfileData: ObservableObject {
    @Published var height: Int?
    @Published var gender: GenderType?
    @Published var clothingType: ClothingType?
    
    @Published var user: User
    
    init(height: Int? = nil, gender: GenderType? = nil, clothingType: ClothingType? = nil, user: User) {
        self.height = height
        self.gender = gender
        self.clothingType = clothingType
        self.user = user
    }
}
