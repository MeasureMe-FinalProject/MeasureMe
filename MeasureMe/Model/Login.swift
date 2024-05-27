//
//  Login.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 25/05/24.
//

import Foundation

struct LoginResponse: Codable {
    let status: String
    let message: String
    let user: User
}
