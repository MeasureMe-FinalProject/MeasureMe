//
//  Register.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 10/03/24.
//

import Foundation

struct RegisterResponse: Codable {
    let name: String
    let email: String
    let mobile: String
    let password: String
}
