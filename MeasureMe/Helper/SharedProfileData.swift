//
//  SharedProfileData.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 22/04/24.
//

import UIKit

final class SharedProfileData: ObservableObject {
    
    @Published var user: User
    @Published var userProfileImage: UIImage = UIImage(resource: .defaultProfile)
    @Published var measurementResults: [MeasurementResult]?
    
    @Published var height: Int = 0
    @Published var gender: GenderType?
    @Published var clothingType: ClothingType?
    
    @Published var isMeasurementFinished: Bool = false
    
    init(gender: GenderType? = nil, clothingType: ClothingType? = nil, user: User, measurementResults: [MeasurementResult]? = nil) {
        self.gender = gender
        self.clothingType = clothingType
        self.user = user
        if let measurementResults {
            self.measurementResults = Array(measurementResults.sorted(by: { getDate(from: $0.date).compare(getDate(from: $1.date)) == .orderedDescending }))
        }
    }
    
    func getLastThreeMeasurementResults() -> [MeasurementResult]? {
        if let measurementResults {
            return Array(measurementResults.prefix(3))
        } else {
            return nil
        }
    }
    
    func getAllMeasurementResults() -> (results: [MeasurementResult], months: [String])? {
        if let measurementResults {
            let months = measurementResults.map { getMonth(from: $0.date) }
            return (measurementResults, months)
        } else {
            return (nil)
        }
    }
    
    func getMonth(from dateString: String) -> String {
        let date = getDate(from: dateString)
        
        // Date to Month(String)
        let dateToMonthFormatter = DateFormatter()
        dateToMonthFormatter.dateFormat = "MMMM"
        let month = dateToMonthFormatter.string(from: date)
                
        return month
    }
    
    private func getDate(from dateString: String) -> Date {
        // Convert String to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy, HH:mm"

        guard let date = dateFormatter.date(from: dateString) else { return Date() }
        return date
    }
    
    func remove(measurementResult: MeasurementResult, completed: @escaping (AlertItem?, Bool) -> Void) {
        if let index = measurementResults!.firstIndex(of: measurementResult) {
            measurementResults?.remove(at: index)
        }
        
        if measurementResults?.count == 0 {
            measurementResults = nil
        }
        
        NetworkManager.shared.deleteMeasurementResult(of: self.user, with: measurementResult.id!) { httpURLResponse in
            switch httpURLResponse.statusCode {
            case 200:
                DispatchQueue.main.async {
                    completed(.successDelete, true)
                }
            default:
                break
            }
        }
    }
}
