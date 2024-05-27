//
//  HistoryViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 11/03/24.
//

import Foundation
import SwiftUI

final class HistoryViewModel: ObservableObject {
    
    @Published var isShowRemoveButton: Bool = false
    @Published var selectedMeasurementResult: MeasurementResult?
    @Published var isShowEmptyStateView: Bool = false
    @Published var isShowAlertMessage: Bool = false
    @Published var alertItem: AlertItem?
    
//    #warning("It needs an API for removing the measurementResult on DB")
    
    func showPopUpAlert(_ alertItem: AlertItem?, _ isShowAlertError: Bool) {
        self.alertItem = alertItem
        self.isShowAlertMessage = isShowAlertError
    }
}
