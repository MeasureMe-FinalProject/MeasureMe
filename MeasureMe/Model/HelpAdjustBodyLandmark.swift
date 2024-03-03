//
//  AdjustmentHelp.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 01/03/24.
//

import Foundation

struct HelpAdjustBodyLandmarkPage: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let image: String
}

enum HelpAdjustBodyLandmarkContent: CaseIterable {
    case pageOne
    case pageTwo
    case pageThree
    
    var image: String {
        switch self {
        case .pageOne:
            "adjustment-help-vector-1"
        case .pageTwo:
            "adjustment-help-vector-2"
        case .pageThree:
            "adjustment-help-vector-3"
        }
    }
    
    var title: String {
        switch self {
        case .pageOne:
            "Adjusting Points"
        case .pageTwo:
            "Head and Heel"
        case .pageThree:
            "Circumferences"
        }
    }
    
    var description: String {
        switch self {
        case .pageOne:
            "To adjust measurement points, drag a body landmark point that represent by blue circle and move it to its position."
        case .pageTwo:
            "To ensure accuracy of result check the top of the head and bottom of the heel key points for both front and side images"
        case .pageThree:
            "Make sure the circumference is a key points are aligned on the edge of the body sillhouette on both front and side images"
        }
    }
}
