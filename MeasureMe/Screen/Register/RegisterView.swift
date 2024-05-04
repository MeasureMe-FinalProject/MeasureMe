//
//  RegisterView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/03/24.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel: RegisterViewModel = RegisterViewModel()
    @Binding var isShow: Bool
    @FocusState var isNameFieldFocused: Bool
    @FocusState var isEmailFieldFocused: Bool
    @FocusState var isPasswordFieldFocused: Bool

    var body: some View {
        VStack {
            createHeaderLogo()
            
            Spacer()
            
            createTitle()
            
            createNameTextField()
            
            createEmailTextField()
                        
            createPasswordTextField()
            
            Spacer()
            
            createSignUpButton()
            
            createSignInButton()
        }
        .onChange(of: viewModel.isRegisterSuccess) {
            isShow = viewModel.isRegisterSuccess
        }
        .padding()
        .alert("Invalid Form", isPresented: $viewModel.isShowAlertError, presenting: viewModel.alertItem) { alertItem in
            Button("OK") {
                viewModel.alertItem = nil
                viewModel.isShowAlertError.toggle()
            }
        } message: { alertItem in
            Text("\(alertItem.message)")
        }
        .alert("Success", isPresented: $viewModel.isRegisterSuccess, presenting: viewModel.alertItem) { alertItem in
            Button("OK") {
                isShow.toggle()
                viewModel.alertItem = nil
                viewModel.isRegisterSuccess.toggle()
            }
        } message: { alertItem in
            Text("\(alertItem.message)")
        }
    }
    
    @ViewBuilder private func createSignInButton() -> some View {
        HStack(spacing: 0) {
            Text("Already have an account?")
                .font(.system(.caption2, weight: .semibold))
                .foregroundStyle(.secondary)
            
            Button {
                isShow.toggle()
            } label: {
                Text(" Sign in")
                    .font(.system(.footnote))
                    .foregroundStyle(.blue)
            }
        }
    }
    
    @ViewBuilder private func createSignUpButton() -> some View {
        Button {
            viewModel.signUpButtonTapped()
        } label: {
            Text("Sign up")
                .font(.system(.body, weight: .semibold))
                .foregroundStyle(.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.blue)
                }
        }
        .padding()
    }
    
    @ViewBuilder private func createPasswordTextField() -> some View {
        CustomTextField(title: "Password", icon: "lock",
                        placeholder: "yourpassword",
                        value: $viewModel.password,
                        isSecureTextField: $viewModel.isHidePassword,
                        isFieldFocused: $isPasswordFieldFocused)
        .textInputAutocapitalization(.never)
        .overlay(alignment: .trailing) {
            Button {
                viewModel.isHidePassword.toggle()
            } label: {
                Image(systemName: viewModel.isHidePassword ? "eye" : "eye.slash")
                    .imageScale(.large)
            }
            .padding(.top, 5)
            .padding(.trailing, 30)
        }
    }
    
    @ViewBuilder private func createEmailTextField() -> some View {
        CustomTextField(title: "Email", icon: "envelope",
                        placeholder: "example@youremail.com",
                        value: $viewModel.email,
                        isFieldFocused: $isEmailFieldFocused)
        .keyboardType(.emailAddress)
        .textInputAutocapitalization(.never)
    }
    
    @ViewBuilder private func createNameTextField() -> some View {
        CustomTextField(title: "Name", icon: "person",
                        placeholder: "Full Name",
                        value: $viewModel.name,
                        isFieldFocused: $isNameFieldFocused)
        .textInputAutocapitalization(.words)
        .padding(.top)
    }
    
    @ViewBuilder private func createTitle() -> some View {
        VStack(alignment: .leading) {
            Text("Sign up")
                .font(.system(.title, weight: .bold))
            
            Text("Register your account!")
                .font(.system(.callout))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    @ViewBuilder private func createHeaderLogo() -> some View {
        Image(.headerLogo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 50)
            .padding(.horizontal)
    }
}

#Preview {
    RegisterView(isShow: .constant(true))
}

struct CustomTextField: View {
    
    let title: String
    let icon: String
    let placeholder: String
    @Binding var value: String
    @Binding var isSecureTextField: Bool
    var isFieldFocused: FocusState<Bool>.Binding
    
    init(title: String, icon: String, placeholder: String, value: Binding<String>, isSecureTextField: Binding<Bool> = .constant(false), isFieldFocused: FocusState<Bool>.Binding) {
        self.title = title
        self.icon = icon
        self.placeholder = placeholder
        self._value = value
        self._isSecureTextField = isSecureTextField
        self.isFieldFocused = isFieldFocused
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                
                Text(title)
            }
            .font(.system(.caption, weight: .semibold))
            .foregroundStyle(isFieldFocused.wrappedValue ? .blue : .secondary)
            
            if isSecureTextField {
                SecureField(placeholder, text: $value)
                    .font(.system(.subheadline, weight: .regular))
                    .textFieldStyle(.plain)
                    .focused(isFieldFocused)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .fill(isFieldFocused.wrappedValue ? .blue : .secondary)
                            .shadow(color: isFieldFocused.wrappedValue ? .blue.opacity(0.4) : .white, radius: 5)
                    }
                    .autocorrectionDisabled()
            } else {
                TextField(placeholder, text: $value)
                    .font(.system(.subheadline, weight: .regular))
                    .textFieldStyle(.plain)
                    .focused(isFieldFocused)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .fill(isFieldFocused.wrappedValue ? .blue : .secondary)
                            .shadow(color: isFieldFocused.wrappedValue ? .blue.opacity(0.4) : .white, radius: 5)
                        
                    }
                    .autocorrectionDisabled()
            }
            
            
        }
        .padding([.horizontal, .bottom])
    }
}
