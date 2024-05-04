//
//  LoginViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/03/24.
//

import Foundation

final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isHidePassword: Bool = true
    @Published var isShowRegisterView: Bool = false
    @Published var alertItem: AuthenticationAlert?
    @Published var isShowAlertError: Bool = false
    @Published var userInformation: User?
    @Published var isLoginSuccess: Bool = false
    
    var isValidForm: Bool {
        guard !email.isEmpty && !password.isEmpty else {
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
    
    func signInButtonTapped() {
        guard isValidForm else { return }
        NetworkManager.shared.makeSignInRequest(email: email, password: password) { response  in
            print(String(describing: response))
            guard let response else {
                DispatchQueue.main.async {
                    self.alertItem = AuthenticationAlert.invalidUser
                    self.isShowAlertError = true
                    print("error kocak")
                    
//                    print(response?.email)
                }
                return
            }
            
            DispatchQueue.main.async {
                let encoder = JSONEncoder()
                let data = try? encoder.encode(response)
                UserDefaults.standard.setValue(data, forKey: "user")
                self.isLoginSuccess = true
                self.userInformation = response
                print("wah bisa")

            }
        }
    }
}
