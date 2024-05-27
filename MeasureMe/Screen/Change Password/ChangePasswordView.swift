//
//  ChangePasswordView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 04/05/24.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @StateObject var viewModel: ChangePasswordViewModel = ChangePasswordViewModel()
    @EnvironmentObject var sharedProfileData: SharedProfileData
    @FocusState var isCurrentPasswordFieldFocused: Bool
    @FocusState var isNewPasswordFieldFocused: Bool
    @FocusState var isConfirmationPasswordFocused: Bool

    var body: some View {
        VStack {
            VStack {
                createTextField(title: "Old Password",
                                placeholder: "Old password",
                                value: $viewModel.oldPassword,
                                isFieldFocused: $isCurrentPasswordFieldFocused)
                
                createTextField(title: "New Password",
                                placeholder: "New password",
                                value: $viewModel.newPassword,
                                isFieldFocused: $isNewPasswordFieldFocused)
                
                createTextField(title: "Confirm New Password",
                                placeholder: "Re-enter your new password",
                                value: $viewModel.confirmationPassword,
                                isFieldFocused: $isConfirmationPasswordFocused)
            }
            .padding(.horizontal)
            
            Spacer()
            
            createConfirmButton()
        }
        .padding(.vertical)
        .navigationTitle("Change Password")
        .alert("Change Password", isPresented: $viewModel
            .isShowAlertMessage, presenting: viewModel.alertItem) { _ in
                Button("OK", role: .cancel) { viewModel.alertItem = nil }
        } message: { alertItem in
            Text(alertItem.message)
        }
    }
    
    @ViewBuilder private func createConfirmButton() -> some View {
        Button {
            viewModel.changePassword(of: sharedProfileData.user, with: viewModel.confirmationPassword)
        } label: {
            Text("Confirm")
                .foregroundStyle(.white)
                .font(.system(.subheadline, weight: .semibold))
                .frame(maxWidth: .infinity, maxHeight: 44)
                .background(Color.appPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal)
        .padding(.horizontal)
    }
    
    @ViewBuilder private func createTextField(title: String,
                                              placeholder: String,
                                              value: Binding<String>,
                                              isFieldFocused: FocusState<Bool>.Binding) -> some View {
        CustomTextField(title: title, icon: "",
                        placeholder: placeholder,
                        value: value,
                        isFieldFocused: isFieldFocused)
        .textInputAutocapitalization(.never)
    }
}

#Preview {
    ChangePasswordView()
        .environmentObject(SharedProfileData(user: .dummyUser))
}
