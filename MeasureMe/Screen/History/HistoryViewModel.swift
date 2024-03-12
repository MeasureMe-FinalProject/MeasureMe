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
    
    @Published var dummyRecentResults: [Result] = [
        Result(name: "Body Measurement", icon: "📐", date: .now),
        Result(name: "Body Measurement", icon: "📐", date: .now),
        Result(name: "Size Recommendation", icon: "👕", date: .now),
        Result(name: "Size Recommendation", icon: "🩳", date: .now + 2000000),
        Result(name: "Size Recommendation", icon: "👖", date: .now + 4000000),
        Result(name: "Size Recommendation", icon: "🧥", date: .now + 6000000),
        Result(name: "Body Measurement", icon: "📐", date: .now + 6500000),
        Result(name: "Size Recommendation", icon: "👕", date: .now + 6600000),
        Result(name: "Size Recommendation", icon: "👖", date: .now + 10000000),
        Result(name: "Size Recommendation", icon: "👕", date: .distantFuture),
        Result(name: "Size Recommendation", icon: "🩳", date: .distantFuture)

    ].sorted { $0.date.compare($1.date) == .orderedDescending }
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter
    }
    
    var measurementResultMonths: [String] {
        dummyRecentResults.map { dateFormatter.string(from: $0.date)}
    }
    
    func remove(measurementResult: Result, from history: Binding<[Result]>) {
        if let index = history.wrappedValue.firstIndex(of: measurementResult) {
            history.wrappedValue.remove(at: index)
        }
    }
}
