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
        .fullScreenCover(isPresented: $viewModel.isSignUp) {
            RegisterView()
        }
    }
    
    @ViewBuilder private func createSignUpButton() -> some View {
        HStack(spacing: 0) {
            Text("Don't have an account?")
                .font(.system(.caption2, weight: .semibold))
                .foregroundStyle(.secondary)

            Button {
                viewModel.isSignUp.toggle()
            } label: {
                Text(" Sign up")
                    .font(.system(.footnote))
                    .foregroundStyle(.blue)
            }
        }
    }
    
    @ViewBuilder private func createSignInButton() -> some View {
        Button {
            
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
        VStack(alignment: .leading) {
            Text("Password")
                .font(.system(.caption, weight: .semibold))
                .foregroundStyle(isPasswordFieldFocused ? .blue : .secondary)
            
            SecureField("Password", text: $viewModel.password)
                .font(.system(.subheadline, weight: .regular))
                .textFieldStyle(.plain)
                .focused($isPasswordFieldFocused)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .fill(isPasswordFieldFocused ? .blue : .secondary)
                        .shadow(color: isPasswordFieldFocused ? .blue.opacity(0.4) : .white, radius: 5)
                }
        }
        .padding([.horizontal, .bottom])
    }
    
    @ViewBuilder private func createEmailTextField() -> some View {
        VStack(alignment: .leading) {
            Text("Email")
                .font(.system(.caption, weight: .semibold))
                .foregroundStyle(isEmailFieldFocused ? .blue : .secondary)
            
            TextField("example@youremail", text: $viewModel.email)
                .font(.system(.subheadline, weight: .regular))
                .textFieldStyle(.plain)
                .focused($isEmailFieldFocused)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .fill(isEmailFieldFocused ? .blue : .secondary)
                        .shadow(color: isEmailFieldFocused ? .blue.opacity(0.4) : .white, radius: 5)

                }
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
        }
        .padding()
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
