//
//  EmptyStateView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 13/05/24.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack {            
            Spacer()
            
            Image(.notfoundVector)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.all, 40)
            
            Text("Oops! No Measurement Result")
                .font(.system(.title3, weight: .semibold))
                .padding(.bottom, 5)
            
            Text("It seems like there are no measurement results available. Please do your measurement first!")
                .font(.system(.subheadline))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom)
            
            Spacer()
        }

    }
}

#Preview {
    EmptyStateView()
}
