//
//  EditProfileView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 04/05/24.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    
    @StateObject var viewModel: EditProfileViewModel = EditProfileViewModel()
    @FocusState var isNameFieldFocused
    @FocusState var isEmailFieldFocused
    @FocusState var isPickerDateFocused
    @EnvironmentObject var sharedProfileData: SharedProfileData
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                createNameTextField()
                
                createEmailTextField()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Edit Profile")
        .scrollIndicators(.hidden)
        .toolbar { createSaveButton() }
        .alert("Edit Profile", isPresented: $viewModel.isShowMessageAlert, presenting: viewModel.alertItem) { alertItem in
            Button("OK", role: .cancel) { viewModel.alertItem = nil }
        } message: {
            alertItem in Text("\(alertItem.message)")
        }
        .onAppear {
            viewModel.name = sharedProfileData.user.name
            viewModel.email = sharedProfileData.user.email
        }
    }
    
    @ViewBuilder private func createSaveButton() -> some View {
        Button {
            viewModel.saveChanges(of: $sharedProfileData.user, dismiss: dismiss)
        } label: {
            Text("Save")
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
}

#Preview {
    EditProfileView()
        .environmentObject(SharedProfileData(user: User.dummyUser))
}
