//
//  ContentView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 17/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowSplashScreen: Bool = true
    
    var body: some View {
        if isShowSplashScreen {
            SplashScreen(isShowSplashScreen: $isShowSplashScreen)
        } else {
            if let data = UserDefaults.standard.data(forKey: "user"),
               let user = try? JSONDecoder().decode(User.self, from: data) {
                MainView(sharedProfileData: SharedProfileData(user: user))
            } else {
                OnBoardingView()
            }
        }
    }
}

#Preview {
    ContentView()
}
