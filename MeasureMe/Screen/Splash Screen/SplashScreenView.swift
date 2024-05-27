//
//  SplashScreenView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 17/05/24.
//

import SwiftUI

struct SplashScreen: View {
    @Binding var isShowSplashScreen: Bool
    
    var body: some View {
        ZStack {
            Color.appPrimary
                .ignoresSafeArea()
            
            Image("app-logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            self.isShowSplashScreen = false
                        }
                    }
                }
        }
    }
}

#Preview {
    SplashScreen(isShowSplashScreen: .constant(true))
}
