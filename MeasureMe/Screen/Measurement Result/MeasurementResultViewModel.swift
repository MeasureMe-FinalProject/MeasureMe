//
//  MeasurementResultViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/04/24.
//

import SwiftUI

final class MeasurementResultViewModel: ObservableObject {
    
    @Published var selectedDetail: MeasurementDetail?
    @Published var isShowMeasurementDetail: Bool = false
    @Published var settingsDetent = PresentationDetent.medium
    
    let measurementDetails: [MeasurementDetail]
    
    init(measurementDetails: [MeasurementDetail]) {
        self.measurementDetails = measurementDetails
    }
    
    private let date: Date = Date()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "HH:mm - dd-MM-YYYY"
        return formatter
    }()
    
    var formattedDate: String {
        dateFormatter.string(from: date)
    }
    
}
