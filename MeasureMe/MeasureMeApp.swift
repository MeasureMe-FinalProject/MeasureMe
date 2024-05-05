//
//  MeasureMeApp.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 02/03/24.
//

import SwiftUI

@main
struct MeasureMeApp: App {
    var body: some Scene {
        WindowGroup {
            if let data = UserDefaults.standard.data(forKey: "user"),
               let user = try? JSONDecoder().decode(User.self, from: data) {
                MainView(sharedProfileData: SharedProfileData(user: user))
            } else {
                OnBoardingView()
            }
            
//            MainView(sharedProfileData: SharedProfileData(user: .dummyUser))
        }
    }
}
