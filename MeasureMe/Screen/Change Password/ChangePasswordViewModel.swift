//
//  ChangePasswordViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 04/05/24.
//

import Foundation

final class ChangePasswordViewModel: ObservableObject {
    @Published var oldPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmationPassword: String = ""
    
    @Published var isShowAlertMessage: Bool = false
    @Published var alertItem: AlertItem?
    
    var isNewPasswordSame: Bool {
        newPassword == confirmationPassword
    }
    
    func changePassword(of user: User, with newPassword: String) {
        guard oldPassword.isValidPassword,
              self.newPassword.isValidPassword,
              confirmationPassword.isValidPassword else {
            alertItem = .invalidPassword
            isShowAlertMessage = true
            return
        }
        
        guard isNewPasswordSame else {
            alertItem = .invalidConfirmationPassword
            isShowAlertMessage = true
            return
        }
        
        NetworkManager.shared.changePassword(for: user.email, oldPassword: oldPassword, newPassword: newPassword) { httpURLResponse in
            DispatchQueue.main.async {
                switch httpURLResponse.statusCode {
                case 200:
                    self.alertItem = .successChangedPassword
                    self.isShowAlertMessage = true
                    
                case 401:
                    self.alertItem = .incorrectOldPassword
                    self.isShowAlertMessage = true
                    
                default:
                    break;
                }
            }
        }
    }
}
