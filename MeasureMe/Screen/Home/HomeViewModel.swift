//
//  HomeViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 21/02/24.
//

import UIKit

final class HomeViewModel: ObservableObject {
    @Published var isShowNewMeasurementView: Bool = false
    @Published var isShowARRuler: Bool = false
    @Published var selectedMeasurementResult: MeasurementResult?
}
