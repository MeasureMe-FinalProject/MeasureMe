//
//  Extensions.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 16/02/24.
//

import Foundation

// Extension for loading the dummy JSON response
extension Bundle {
    func decode<T : Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Couldn't find \(file) in the project")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Couldnt't load \(file) in the project")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Couldn't decode \(file) in the project")
        }
                       
        return loadedData
    }
}

extension BodyLandmarkResponse {
    static let dummyBodyLandmarkResponse: BodyLandmarkResponse = Bundle.main.decode(file: "DummyBodyLandmarkResponse.json")
    static let dummyAdjustedBodyLandmarkResponse: AdjustedBodyLandmarkResponse = Bundle.main.decode(file: "DummyAdjustedBodyLandmark.json")
}
