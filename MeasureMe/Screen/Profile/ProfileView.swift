//
//  Profile.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 25/02/24.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel: ProfileViewModel = ProfileViewModel()
    @EnvironmentObject var sharedProfileData: SharedProfileData

    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack(alignment: .top) {
                    createBackground()
                                
                    VStack {
                        createProfileImage()
                        
                        createNameAndEmailText()
                        
                        createPersonalInformation()
                        
                        createShowMoreInformation()
                        
//                        createShowMoreButton()
                    }
                    .padding(.top, 180)
                    .padding(.horizontal)
                }
                .background(.appPrimary)
                .overlay { createNavigationTitle() }
                .alert(isPresented: $viewModel.isShowLogOutAlert) { createAlert() }
                .navigationDestination(isPresented: $viewModel.isShowLoginView) {
                    LoginView()
                        .navigationBarBackButtonHidden()
                        .toolbar(.hidden, for: .tabBar)
                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }
    
    private func createAlert() -> Alert {
        Alert(title: Text("Logout"),
              message: Text("Are you sure you want to logout?"),
              primaryButton: .cancel(),
              secondaryButton: .destructive(Text("Logout")) {
            
            viewModel.isShowLoginView = true
            UserDefaults.standard.removeObject(forKey: "user")
            
        })
    }
    
    @ViewBuilder private func createShowMoreButton() -> some View {
        Button {
            withAnimation(.interactiveSpring) {
                viewModel.isShowMoreInformation.toggle()
            }
        } label: {
            Text(viewModel.isShowMoreInformation ? "Show Less" : "Show More")
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 50)
    }
    
    @ViewBuilder private func createShowMoreInformation() -> some View {
//        if viewModel.isShowMoreInformation {
            VStack (alignment: .leading) {
                Text("Account")
                    .font(.system(.title3, weight: .semibold))
                    .padding(.horizontal)
                
                List {
                    NavigationLink {
                        EditProfileView()
                            .toolbar(.hidden, for: .tabBar)
                        } label: {
                        HStack {
                            Image(systemName: "person.text.rectangle")
                            
                            Text("Edit Profile")
                            
                            Spacer()
                            
                        }
                    }
                    
                    NavigationLink {
                        ChangePasswordView()
                            .toolbar(.hidden, for: .tabBar)
                    } label: {
                        HStack {
                            Image(systemName: "person.badge.key.fill")
                            
                            Text("Change Password")
                            
                            Spacer()
                            
                        }
                    }
                                    
                    Button {
                        viewModel.isShowLogOutAlert = true
                    } label: {
                        HStack {
                            Image("logout-icon")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .foregroundStyle(.red)
                            
                            Text("Logout")
                                .foregroundStyle(.red)

                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(.subheadline, weight: .medium))
                                .foregroundStyle(.secondary.opacity(0.5))
                            
                        }
                    }
                }
                            .scrollDisabled(true)
                .listStyle(.plain)
                .frame(maxHeight: .infinity)
                .frame(height: 150)
            }
//        }
    }

    
    @ViewBuilder private func createPersonalInformation() -> some View {
        if let gender = sharedProfileData.gender?.name {
            VStack (alignment: .leading) {
                Text("Personal Info")
                    .font(.system(.title3, weight: .semibold))
                    .padding(.horizontal)
                
                List {
                    HStack {
                        Image(systemName: "figure.dress.line.vertical.figure")
                        
                        Text("Gender")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text(gender)
                        
                    }
                    
                    HStack {
                        Image(systemName: "ruler")
                        Text("Height")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text("\(sharedProfileData.height) cm")
                        
                    }
                }
                .scrollDisabled(true)
                .listStyle(.plain)
                .frame(height: 110)
            }
        }
    }
    
    @ViewBuilder private func createNameAndEmailText() -> some View {
        Text(sharedProfileData.user.name)
            .font(.system(.title, weight: .bold))
        
        Text(sharedProfileData.user.email)
            .font(.system(.body))
            .foregroundStyle(.secondary)
        
        Divider()
            .padding(.horizontal)
            .padding(.vertical)
    }
    
    @ViewBuilder private func createProfileImage() -> some View {
        Image("default-profile-image")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background {
                Circle()
                    .fill(.white)
                    .overlay {
                        Circle()
                            .stroke(lineWidth: 2).fill(.white)
                    }
                    .shadow(color: .black.opacity(0.5), radius: 10)
            }
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.5), radius: 10)
            .frame(width: 150, height: 150)
    }
    
    @ViewBuilder private func createNavigationBar() -> some View {
        Rectangle()
            .foregroundStyle(.background)
            .shadow(color: .black.opacity(0.075), radius: 3, y: 4)
            .frame(height: 100)
            .overlay(alignment: .bottom) {
                Text("History")
                    .font(.system(.body, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
                    .overlay(alignment: .trailing) {
                        Button {
                            withAnimation {
//                                viewModel.isShowRemoveButton.toggle()
                            }
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(.headline, weight: .semibold))
                                .foregroundStyle(.red)
                        }
                        .padding(.trailing, 30)
                        .padding(.bottom)
                    }
            }
            .ignoresSafeArea()
            .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder private func createNavigationTitle() -> some View {
            Text("Profile")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 65)
            .font(.system(.headline, weight: .bold))
            .foregroundStyle(.white)
    }
    
    @ViewBuilder private func createBackground() -> some View {
        Color.appPrimary
            .ignoresSafeArea(edges: .top)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        MountainShape()
            .fill(.background)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .offset(y: sharedProfileData.gender == nil ? UIScreen.main.bounds.height / 11 : 0)
    }
}

#Preview {
    ProfileView()
        .environmentObject(SharedProfileData(gender: .male,user: .dummyUser))
}
