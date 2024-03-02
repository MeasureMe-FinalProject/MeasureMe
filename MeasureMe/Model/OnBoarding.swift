//
//  OnBoarding.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 03/02/24.
//

import Foundation

struct OnBoardingPage: Hashable {
    let image: String
    let headingOne: String
    let headingTwo: String
    let subheading: String
}

enum OnBoardingContent {
    case pageOne
    case pageTwo
    case pageThree
    
    var imageVector: String {
        switch self {
        case .pageOne:
            "on-boarding-vector-1"
        case .pageTwo:
            "on-boarding-vector-2"
        case .pageThree:
            "on-boarding-vector-3"
            
        }
    }
    
    var headingOne: String {
        switch self {
        case .pageOne:
            "Easy"
        case .pageTwo:
            "Size"
        case .pageThree:
            "Shopping"
        }
    }
    
    var headingTwo: String {
        switch self {
        case .pageOne:
            "Measuring"
        case .pageTwo:
            "Recommendation"
        case .pageThree:
            "Appropriately"
        }
    }
    
    var subheading: String {
        switch self {
        case .pageOne:
            "Measure your body easily and simply using only a smartphone."
        case .pageTwo:
            "Get recommendations for your clothing size after doing body measurements."
        case .pageThree:
            "Get the peace of mind that you are shopping for clothes in the right size."
        }
    }
    
}
