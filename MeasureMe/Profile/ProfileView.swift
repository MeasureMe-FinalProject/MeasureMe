//
//  Profile.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 25/02/24.
//

import SwiftUI

struct ProfileView: View {
    
    var body: some View {
        NavigationStack {
            NavigationLink {
                LoginView()
                    .onAppear {UserDefaults.standard.removeObject(forKey: "user")}
                    .toolbar(.hidden, for: .tabBar)
                    .navigationBarBackButtonHidden()
            } label: {
                Text("Logout")
            }
        }
    }
}

#Preview {
    ProfileView()
}
