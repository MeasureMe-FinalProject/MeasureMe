//
//  HomeViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 21/02/24.
//

import UIKit

final class HomeViewModel: ObservableObject {
    @Published var isShowNewMeasurementView: Bool = false
    @Published var recentMeasurementResults: [RecentMeasurementResult]?
    
    init(recentMeasurementResults: [RecentMeasurementResult]? = nil) {
        if let recentMeasurementResults {
            self.recentMeasurementResults = Array(recentMeasurementResults.sorted(by: { $0.id > $1.id }).prefix(3))
        }
    }
    
//    func getRecentMeasurementResult(user: User) {
//        NetworkManager.shared.getRecentMeasurementResults(of: user) { response, httpURLResponse in
//            guard let response else { return }
//            
//            DispatchQueue.main.async {
//                
//                // Sort with the most recent result and only show the first three
//                self.recentMeasurementResults = Array(response.sorted(by: { $0.id > $1.id }).prefix(3))
//            }
//        }
//    }
}
