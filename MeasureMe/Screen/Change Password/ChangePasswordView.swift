//
//  ChangePasswordView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 04/05/24.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @StateObject var viewModel: ChangePasswordViewModel = ChangePasswordViewModel()
    @FocusState var isCurrentPasswordFieldFocused: Bool
    @FocusState var isNewPasswordFieldFocused: Bool
    @FocusState var isConfirmationPasswordFocused: Bool

    var body: some View {
        VStack {
            VStack {
                createTextField(title: "Current Password",
                                placeholder: "Current password",
                                value: $viewModel.currentPassword,
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
            
            createSaveButton()
        }
        .padding(.vertical)
        .navigationTitle("Change Password")
    }
    
    @ViewBuilder private func createSaveButton() -> some View {
        Button {
            withAnimation {
            }
        } label: {
            Text("Save")
                .foregroundStyle(.background)
                .font(.system(.subheadline, weight: .semibold))
                .frame(maxWidth: .infinity, maxHeight: 44)
                .background(Color.blue)
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
        .textInputAutocapitalization(.words)
        .padding(.top)
    }
}

#Preview {
    ChangePasswordView()
}
