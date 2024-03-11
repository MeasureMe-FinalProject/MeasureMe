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
    static let invalidForm = AuthenticationAlert(message: "There's an empty form\nPlease fill out all the information")
    
    static let invalidEmail = AuthenticationAlert(message: "Please enter a valid email address")
    
    static let invalidPassword = AuthenticationAlert(message: "Password must have at least 8 character")
    
    static let invalidUser = AuthenticationAlert(message: "We can't find an account witht this email address. Please try again or create a new account")
    
    static let registeredEmail = AuthenticationAlert(message: "This email address is already exists in our database. Please try to sign in with this email")
    
    static let successfullyRegister = AuthenticationAlert(message: "Congratulations! your account has been successfully created")
}

