//
//  ChangePasswordViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 04/05/24.
//

import Foundation

final class ChangePasswordViewModel: ObservableObject {
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmationPassword: String = ""
    
//    var isPasswordCorrect: Bool {
//        currentPassword == 
//    }
//    var isNewPasswordSame: Bool {
//        newPassword == confirmationPassword
//    }
}
