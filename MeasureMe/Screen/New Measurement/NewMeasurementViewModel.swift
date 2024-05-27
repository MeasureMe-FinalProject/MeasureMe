//
//  NewMeasurementViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 26/02/24.
//

import Foundation

enum GenderType: CaseIterable, Codable {
    case male
    case female
    
    var name: String {
        switch self {
        case .male:
            "Male"
        case .female:
            "Female"
        }
    }
    
    var imageName: String {
        switch self {
        case .male:
            "male-gender-vector"
        case .female:
            "female-gender-vector"
        }
    }
    
    var codeName: String {
        switch self {
        case .male:
            "MALE"
        case .female:
            "FEMALE"
        }
    }
}

final class NewMeasurementViewModel: ObservableObject {
    @Published var selectedGender: GenderType?
    @Published var height: Int = 0
    @Published var isShowPrivacyMeassage: Bool = false
    @Published var isShowPhotoCaptureView: Bool = false
    @Published var isShowMessageAlert: Bool = false
    
    var paddingHeightImageVector: CGFloat {
        if height <= 0 {
            return 500
        }else if height <= 25 {
            return 150
        } else if height <= 50 {
            return 100
        } else if height <= 100  {
            return 75
        } else if height <= 150 {
            return 50
        } else if height <= 175{
            return 25
        } else {
            return 0
        }
    }
    
    func isValidToCreateNewMeasurement() -> Bool {
        selectedGender != nil && height != 0 ? true : false
    }
}
