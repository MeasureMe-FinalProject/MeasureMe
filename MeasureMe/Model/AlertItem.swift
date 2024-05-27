//
//  Alert.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 10/03/24.
//

import SwiftUI

struct AlertItem {
    let status: String?
    let message: String
    
    init(status: String? = nil, message: String) {
        self.status = status
        self.message = message
    }
}

extension AlertItem {
    //--MARK: Login and Register Alert
    static let invalidForm = AlertItem(message: "There's an empty form\nPlease fill out all the information.")
    
    static let invalidEmail = AlertItem(message: "Please enter a valid email address.")
    
    static let invalidPassword = AlertItem(message: "Password must have at least 8 character")
    
    static let invalidUser = AlertItem(message: "We can't find the account. Please try again or create a new account.")
    
    static let invalidURL = AlertItem(message: "Oops! Interval server error.\nPlease try again later.")
    
    static let registeredEmail = AlertItem(message: "This email already exists!\nPlease sign in with this email.")
    
    static let successRegister = AlertItem(message: "Congratulations!\nYour account successfully created.")
    
    static let invalidForgotPasswordEmail = AlertItem(message: "The email adddress is not found\nPlease try again.")
    
    static func showForgotPassword(password: String) -> AlertItem {
        return AlertItem(message: "Your password is \(password)")
    }
    
    //--MARK: Delete Measurement Alert
    static let successDelete = AlertItem(status: "Success",
                                   message: "Measurement result deleted successfully.")
    
    //--MARK: Change Password Alert
    static let successChangedPassword = AlertItem(status: "Success",
                                                  message: "Password updated successfully")
    static let incorrectOldPassword = AlertItem(status: "Failed",
                                                  message: "Old password is incorrect")
    static let invalidConfirmationPassword = AlertItem(status: "Failed", message: "Your confirmation password is not same with your new password")
    
    //--MARK: Edit Profile Alert
    static let successUpdateProfile = AlertItem(message: "Profile update successfully")
}

