//
//  RegisterViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/03/24.
//

import Foundation

final class RegisterViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var isHidePassword: Bool = true
    @Published var alertItem: AuthenticationAlert?
    @Published var isShowAlertError: Bool = false
    @Published var isRegisterSuccess: Bool = false
    
    var isValidForm: Bool {
        guard !name.isEmpty && !email.isEmpty && !password.isEmpty else {
            alertItem = AuthenticationAlert.invalidForm
            isShowAlertError = true
            return false
        }
        
        guard email.isValidEmail else {
            alertItem = AuthenticationAlert.invalidEmail
            isShowAlertError = true
            return false
        }
        
        guard password.isValidPassword else {
            alertItem = AuthenticationAlert.invalidPassword
            isShowAlertError = true
            return false
        }
        
        return true
    }

    func signUpButtonTapped() {
        guard isValidForm else { return }
        
        NetworkManager.shared.makeSignUpRequest(name: name,
                                                email: email,
                                                password: password) { response, httpURLResponse  in
            guard let httpURLResponse else {
                self.alertItem = AuthenticationAlert.invalidURL
                print("there is an error with URL")
                return
            }
            
            switch httpURLResponse.statusCode {
            case 201:
                DispatchQueue.main.async {
                    self.alertItem = AuthenticationAlert.successfullyRegister
                    self.isRegisterSuccess = true
                }
                
            case 409:
                DispatchQueue.main.async {
//                    guard let _ = response else {
                        DispatchQueue.main.async {
                            self.alertItem = AuthenticationAlert.registeredEmail
                            self.isShowAlertError = true
                        }
//                        returpn
//                    }
                }
                
            default:
                break
            }
            
            
            
        }
    }
}
