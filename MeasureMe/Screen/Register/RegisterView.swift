//
//  RegisterView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/03/24.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var viewModel: RegisterViewModel = RegisterViewModel()
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
        .padding()
        .fullScreenCover(isPresented: $viewModel.isSignIn) {
            LoginView()
        }
    }
    
    @ViewBuilder private func createSignInButton() -> some View {
        HStack(spacing: 0) {
            Text("Already have an account?")
                .font(.system(.caption2, weight: .semibold))
                .foregroundStyle(.secondary)
            
            Button {
                viewModel.isSignIn.toggle()
            } label: {
                Text(" Sign in")
                    .font(.system(.footnote))
                    .foregroundStyle(.blue)
            }
        }
    }
    
    @ViewBuilder private func createSignUpButton() -> some View {
        Button {
            
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
        .padding([.horizontal, .bottom])
    }
    
    @ViewBuilder private func createNameTextField() -> some View {
        VStack(alignment: .leading) {
            Text("Name")
                .font(.system(.caption, weight: .semibold))
                .foregroundStyle(isEmailFieldFocused ? .blue : .secondary)
            
            TextField("Full Name", text: $viewModel.fullName)
                .font(.system(.subheadline, weight: .regular))
                .textFieldStyle(.plain)
                .focused($isNameFieldFocused)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .fill(isNameFieldFocused ? .blue : .secondary)
                        .shadow(color: isNameFieldFocused ? .blue.opacity(0.4) : .white, radius: 5)

                }
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
        }
        .padding()
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
    RegisterView()
}
