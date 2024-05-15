//
//  Alert.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 10/03/24.
//

import SwiftUI

struct AuthenticationAlert {
    let message: String
}

extension AuthenticationAlert {
    //--MARK: Login and Register Alert
    static let invalidForm = AuthenticationAlert(message: "There's an empty form\nPlease fill out all the information.")
    
    static let invalidEmail = AuthenticationAlert(message: "Please enter a valid email address.")
    
    static let invalidPassword = AuthenticationAlert(message: "Password must have at least 8 character")
    
    static let invalidUser = AuthenticationAlert(message: "We can't find the account. Please try again or create a new account.")
    
    static let invalidURL = AuthenticationAlert(message: "Oops! Interval server error.\nPlease try again later.")
    
    static let registeredEmail = AuthenticationAlert(message: "This email already exists!\nPlease sign in with this email.")
    
    static let successfullyRegister = AuthenticationAlert(message: "Congratulations!\nYour account successfully created.")
}

