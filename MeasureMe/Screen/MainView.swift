//
//  MainView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 25/02/24.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedTab: Tab = .Home
    
    enum Tab {
        case Home
        case History
        case Profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag(Tab.Home)
                .tabItem { Label("Home", systemImage: "house.fill") }

            HistoryView()
                .tag(Tab.History)
                .tabItem { Label("History", image: .pencilRulerIcon) }
            
            ProfileView()
                .tag(Tab.Profile)
                .tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
        }
    }
}

#Preview {
    MainView()
}
