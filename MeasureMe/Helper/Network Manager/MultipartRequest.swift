//
//  MultipartRequest.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 17/02/24.
//

import Foundation

struct MultipartRequest {
    
    let boundary: String
    
    private let separator: String = "\r\n"
    private var data: Data

    init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
        self.data = .init()
    }
    
    var httpContentTypeHeaderValue: String {
        "multipart/form-data; boundary=\(boundary)"
    }

    var httpBody: Data {
        var bodyData = data
        bodyData.appendString("--\(boundary)--")
        return bodyData
    }
    
    mutating func addFormField(
        key: String,
        value: String
    ) {
        appendBoundarySeparator()
        data.appendString(disposition(key) + separator)
        appendSeparator()
        data.appendString(value + separator)
    }

    mutating func addFileData(
        key: String,
        fileName: String,
        fileMimeType: String,
        fileData: Data
    ) {
        appendBoundarySeparator()
        data.appendString(disposition(key) + "; filename=\"\(fileName)\"" + separator)
        data.appendString("Content-Type: \(fileMimeType)" + separator)
        appendSeparator()
        data.append(fileData)
        appendSeparator()
    }
}

// MARK: - Private func

extension MultipartRequest {
    private mutating func appendBoundarySeparator() {
        data.appendString("--\(boundary)\(separator)")
    }
    
    private mutating func appendSeparator() {
        data.appendString(separator)
    }

    private func disposition(_ key: String) -> String {
        "Content-Disposition: form-data; name=\"\(key)\""
    }
}
