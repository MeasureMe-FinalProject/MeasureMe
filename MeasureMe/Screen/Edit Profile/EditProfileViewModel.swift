//
//  EditProfileViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 04/05/24.
//

import SwiftUI
import PhotosUI

final class EditProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    
    @Published var alertItem: AlertItem?
    @Published var isShowMessageAlert: Bool = false
    
    func saveChanges(of user: Binding<User>, dismiss: DismissAction) {
        guard email.isValidEmail else {
            alertItem = .invalidEmail
            isShowMessageAlert = true
            return
        }
        
        let editedUserInfo = User(id: user.wrappedValue.id,
                                  name: name,
                                  email: email,
                                  password: user.wrappedValue.password)
        
        user.wrappedValue = editedUserInfo
        
        NetworkManager.shared.editProfile(of: user.wrappedValue) { response in
            DispatchQueue.main.async {
                
                // Update user information in local
                let encoder = JSONEncoder()
                let data = try? encoder.encode(editedUserInfo)
                UserDefaults.standard.setValue(data, forKey: "user")
                
                self.alertItem = .successUpdateProfile
                self.isShowMessageAlert = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    dismiss()
                }
            }
        }
    }
}
