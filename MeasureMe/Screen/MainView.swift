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
        case MyMeasure
        case Profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag(Tab.Home)
                .tabItem { Label("Home", systemImage: "house.fill") }

            MyMeasureView()
                .tag(Tab.MyMeasure)
                .tabItem { Label("My Measure", image: .pencilRulerIcon) }
            
            ProfileView()
                .tag(Tab.Profile)
                .tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
        }
    }
}

#Preview {
    MainView()
}
