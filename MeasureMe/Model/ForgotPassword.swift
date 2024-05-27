//
//  ForgotPassword.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 25/05/24.
//

import Foundation

struct ForgotPasswordResponse: Codable {
    let status: String
    let message: String
    let password: String
}
