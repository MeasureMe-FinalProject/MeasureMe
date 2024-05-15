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
    @Published var recentMeasurementResults: [RecentMeasurementResult]?
    @Published var measurementResultMonths: [String]?
    @Published var isShowEmptyStateView: Bool = false
    
    init(measurementResults: [RecentMeasurementResult]?) {
        if let measurementResults {
            self.recentMeasurementResults = Array(measurementResults.sorted(by: { $0.id > $1.id }))
            if let recentMeasurementResults {
                self.measurementResultMonths = recentMeasurementResults.map({ getMonth(from: $0.date) })
            }
        }
    }
    
    func getMonth(from dateString: String) -> String {
        // Convert String to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy, HH:mm"

        guard let date = dateFormatter.date(from: dateString) else { return ""}
        
        // Date to Month(String)
        let dateToMonthFormatter = DateFormatter()
        dateToMonthFormatter.dateFormat = "MMMM"
        let month = dateToMonthFormatter.string(from: date)
                
        return month
    }
    
//    func getRecentMeasurementResult(user: User) {
//        NetworkManager.shared.getRecentMeasurementResults(of: user) { [self] response, httpURLResponse in
//            switch httpURLResponse.statusCode {
//            case 200:
//                DispatchQueue.main.async { [self] in
//                    guard let response else { return }
//                    recentMeasurementResults = Array(response.sorted(by: { $0.id > $1.id }))
//                    if let recentMeasurementResults = recentMeasurementResults {
//                        measurementResultMonths = recentMeasurementResults.map({ self.getMonth(from: $0.date) })
//                    }
//                }
//            case 404:
//                DispatchQueue.main.async { [self] in
//                    isShowEmptyStateView = true
//                }
//            default:
//                break
//            }
//        }
//    }
    
    #warning("It needs an API for removing the measurementResult on DB")
    func remove(measurementResult: RecentMeasurementResult) {
        if let recentMeasurementResults {
            if let index = recentMeasurementResults.firstIndex(of: measurementResult) {
                self.recentMeasurementResults?.remove(at: index)
                if recentMeasurementResults.count == 1 {
                    self.measurementResultMonths?.removeAll()
                }
            }
        }
    }
}
