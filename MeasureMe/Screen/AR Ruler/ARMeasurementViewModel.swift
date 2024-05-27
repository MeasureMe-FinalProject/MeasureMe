//
//  ARMeasurementViewModel.swift
//  BodyTrackingBlueprint
//
//  Created by Diki Dwi Diro on 20/01/24.
//

import Foundation

final class ARMeasurementViewModel: ObservableObject {
    
    @Published var distance = "0cm"
    @Published var recommendationString = ""
    @Published var isPlusButtonTapped = false
    @Published var isClearButtonTapped = false
    @Published var isCoachingOverlayEnabled = false
    @Published var shouldButtonDisabled = false
    @Published var isShowCloseAlert = false
}

extension ARMeasurementViewModel {
    func clearButtonTapped() {
        isClearButtonTapped = true
    }
}
