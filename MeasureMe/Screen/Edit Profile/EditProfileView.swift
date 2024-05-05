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
                createProfileImage()
                
                createNameTextField()
                
                createEmailTextField()
                
                createPickerDate()
                
                createGenderChoices()
                
                createBodyHeightSlider()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Edit Profile")
        .scrollIndicators(.hidden)
        .toolbar { createSaveButton() }
        .alert(isPresented: $viewModel.isShowSuccessAlert) {
            Alert(title: Text("Saved"),
                  message: Text("Successfully saved the information."),
                  dismissButton: .default(Text("OK")))
        }
        .onAppear {
            viewModel.name = sharedProfileData.user.name
            viewModel.email = sharedProfileData.user.email
        }
    }
    
    @ViewBuilder private func createSaveButton() -> some View {
        Button {
            let user = User(id: sharedProfileData.user.id,
                            name: viewModel.name,
                            email: viewModel.email,
                            password: sharedProfileData.user.password)
            
            sharedProfileData.user = user
            viewModel.isShowSuccessAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                dismiss()
            }
        } label: {
            Text("Save")
        }
    }
    
    @ViewBuilder private func createBodyHeightSlider() -> some View {
        VStack {
            Text("Height")
                .font(.system(.title2, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            RoundedRectangle(cornerRadius: 14)
                .stroke(lineWidth: 1)
                .fill(.primary.opacity(0.2))
                .background {
                    HStack {
                        VStack {
                            Group {
                                Text("\(Int(viewModel.height)) ")
                                    .font(.system(.title2, weight: .bold))
                                +
                                Text("cm")
                                    .font(.system(.title3, weight: .medium))
                            }
                            .padding(.bottom, viewModel.paddingHeightImageVector)
                            
                            Image("height-vector")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        
                        HeightSlider(height: $viewModel.height)
                    }
                    .padding(.all)
                }
                .clipped()
                .padding(.bottom)
        }
        .frame(height: 350)
        .padding(.top)
        .padding(.horizontal)
        
    }
    
    @ViewBuilder private func createGenderChoices() -> some View {
        Text("Gender")
            .font(.system(.title2, weight: .semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.horizontal)
            .padding(.top)
        
        HStack {
            ForEach(GenderType.allCases, id: \.self) { gender in
                GenderCard(gender: gender, selectedGender: $viewModel.selectedGender)
            }
        }
    }
    
    @ViewBuilder private func createPickerDate() -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 5) {
                Image(systemName: "calendar")
                
                Text("Date of Birth")
            }
            .font(.system(.caption, weight: .semibold))
            .foregroundStyle(isPickerDateFocused ? .blue : .secondary)
            
            
            DatePicker(selection: $viewModel.dateOfBirth, displayedComponents: .date) {
                Text("Your Date Of Birth")
                    .font(.system(.footnote, weight: .regular))
                    .foregroundStyle(.placeholder)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .fill(isPickerDateFocused ? .blue : .secondary)
                    .shadow(color: isPickerDateFocused ? .blue.opacity(0.4) : .white, radius: 5)
                
            }
        }
        .padding([.horizontal, .bottom])
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
    
    
    @ViewBuilder private func createProfileImage() -> some View {
        if let image = viewModel.image {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background {
                    Circle()
                        .fill(.black)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 2).fill(.white)
                        }
                        .shadow(color: .black, radius: 10)
                }
                .overlay(alignment: .bottomTrailing) {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.gray)
                        .overlay {
                            Image(systemName: "camera.fill")
                                .font(.system(.title3))
                                .foregroundStyle(.black)
                                .padding()
                            
                            PhotosPicker("Select avatar", selection: $viewModel.imageItem, matching: .images)
                                .tint(.clear)
                                .font(.system( .largeTitle))
                        }
                }
                .frame(width: 150, height: 150)
                .padding(.vertical)
                .padding(.top)
                .onChange(of: viewModel.imageItem) {
                    Task {
                        if let loaded = try? await viewModel.imageItem?.loadTransferable(type: Image.self) {
                            viewModel.image = loaded
                        } else {
                            print("Failed")
                        }
                    }
                }
        }
        else {
            Image("profile-image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background {
                    Circle()
                        .fill(Color.black)
                        .overlay {
                            Circle()
                                .stroke(lineWidth: 2)
                                .fill(Color.white)
                        }
                        .shadow(color: Color.black, radius: 10)
                }
                .overlay(alignment: .bottomTrailing) {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.gray)
                        .overlay {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color.black)
                                .padding()
                            
                            PhotosPicker("Select avatar", selection: $viewModel.imageItem, matching: .images)
                                .tint(.clear)
                                .font(.system(size: 20))
                        }
                }
                .frame(width: 150, height: 150)
                .padding(.vertical)
                .padding(.top)

        }
    }
}

#Preview {
    EditProfileView()
        .environmentObject(SharedProfileData(user: User.dummyUser))
}
