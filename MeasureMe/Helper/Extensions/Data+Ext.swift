//
//  Data+Ext.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 16/02/24.
//

import Foundation

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
