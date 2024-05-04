//
//  ProcessStateView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 24/04/24.
//

import SwiftUI

struct ProcessStateView: View {
    var body: some View {
        VStack {
            Image(.headerLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 45)
            
            Spacer()
            
            Image(.photoProcessVector)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.all, 40)
            
            Text("We're Preparing Your Result")
                .font(.system(.title3, weight: .semibold))
                .padding(.bottom, 5)
            
            Text("Don't leave this screen until the processing has been completed")
                .font(.system(.subheadline))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 35)
                .padding(.bottom)
            
            ProgressView()
            
            Spacer()
        }

    }
}

#Preview {
    ProcessStateView()
}
