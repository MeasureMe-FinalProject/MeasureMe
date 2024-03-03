//
//  UndetectedBodyView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 02/03/24.
//

import SwiftUI

struct UndetectedBodyView: View {
    
    @Binding var isCapturingComplete: Bool
    @Binding var capturedImages: [UIImage]
    
    var body: some View {
        ZStack {
            VStack {
                Image(.headerLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 45)
                
                Spacer()
                
                Image(.undetectedBodyVector)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.all, 40)
                
                Text("Oops! we can't detect your body")
                    .font(.system(.title3, weight: .semibold))
                    .padding(.bottom, 5)
                
                Text("Please ensure that your background contrasts with your body, and also ensure that your area has sufficient lighting.")
                    .font(.system(.subheadline))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom)
                
                Spacer()
                
                createNextButton()
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder private func createNextButton() -> some View {
        Button {
            isCapturingComplete.toggle()
            capturedImages = []
        } label: {
            Text("Retake Photo")
                .foregroundStyle(.background)
                .font(.system(.subheadline, weight: .semibold))
                .frame(maxWidth: .infinity, maxHeight: 44)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
    }
}

#Preview {
    UndetectedBodyView(isCapturingComplete: .constant(false), capturedImages: .constant([.frontPreview1, .sidePreview1]))
}
