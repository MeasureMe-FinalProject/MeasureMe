//
//  MainView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 25/02/24.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedTab: Tab = .Home
    @ObservedObject var sharedProfileData: SharedProfileData
    
    enum Tab {
        case Home
        case History
        case Profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: HomeViewModel(recentMeasurementResults: sharedProfileData.measurementResults))
                .tag(Tab.Home)
                .tabItem { Label("Home", systemImage: "house.fill") }
            
            HistoryView(viewModel: HistoryViewModel(measurementResults: sharedProfileData.measurementResults))
                .tag(Tab.History)
                .tabItem { Label("History", image: .pencilRulerIcon) }
            
            ProfileView()
                .tag(Tab.Profile)
                .tabItem { Label("Profile", systemImage: "person.fill") }
        }
        .onAppear {
            DispatchQueue.main.async {
                NetworkManager.shared.getRecentMeasurementResults(of: sharedProfileData.user) { response, _ in
                    sharedProfileData.measurementResults = response
                }
            }
        }
        .environmentObject(sharedProfileData)
    }
}

#Preview {
    MainView(sharedProfileData: SharedProfileData(gender: .male,user: .dummyUser))
}
