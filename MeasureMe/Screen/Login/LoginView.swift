//
//  LoginView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/03/24.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel: LoginViewModel = LoginViewModel()
    @FocusState var isEmailFieldFocused: Bool
    @FocusState var isPasswordFieldFocused: Bool

    var body: some View {
        NavigationStack {
            VStack {
                createHeaderLogo()
                
                Spacer()
                
                createTitle()
                
                createEmailTextField()
                
                createPasswordTextField()
                
                createForgotPasswordButton()
                
                Spacer()
                
                createSignInButton()
                
                createSignUpButton()
            }
            .padding()
            .fullScreenCover(isPresented: $viewModel.isShowRegisterView) {
                RegisterView(isShow: $viewModel.isShowRegisterView)
            }
            .alert("Invalid Form", isPresented: $viewModel.isShowAlertError, presenting: viewModel.alertItem) { alertItem in
                Button("OK") {
                    viewModel.alertItem = nil
                    viewModel.isShowAlertError.toggle()
                }
            } message: { alertItem in Text("\(alertItem.message)") }
                .fullScreenCover(isPresented: $viewModel.isLoginSuccess) {
                    if let user = viewModel.userInformation {
                        MainView(sharedProfileData: SharedProfileData(user: user))
                    }
                }
        }
    }
    
    @ViewBuilder private func createSignUpButton() -> some View {
        HStack(spacing: 0) {
            Text("Don't have an account?")
                .font(.system(.caption2, weight: .semibold))
                .foregroundStyle(.secondary)

            Button {
                viewModel.isShowRegisterView.toggle()
                viewModel.email = ""
                viewModel.password = ""
            } label: {
                Text(" Sign up")
                    .font(.system(.footnote))
                    .foregroundStyle(.blue)
            }
        }
    }
    
    @ViewBuilder private func createSignInButton() -> some View {
        Button {
            viewModel.signInButtonTapped()
        } label: {
            Text("Sign in")
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
    
    @ViewBuilder private func createForgotPasswordButton() -> some View {
        Button {
            
        } label: {
            Text("Forgot password?")
                .font(.system(.caption, weight: .semibold))
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing)
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
    
    @ViewBuilder private func createTitle() -> some View {
        VStack(alignment: .leading) {
            Text("Sign in")
                .font(.system(.title, weight: .bold))
            
            Text("Welcome back!")
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
    LoginView()
}
