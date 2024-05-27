//
//  BodyLandmarkProcessView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 24/04/24.
//

import SwiftUI

struct BodyLandmarkProcessView: View {
    
    @ObservedObject var viewModel: BodyLandmarkProcessViewModel
    @EnvironmentObject var sharedProfileData: SharedProfileData
    
    var body: some View {
        ZStack {
            if viewModel.isShowMeasurementResultView {
                MeasurementResultView(viewModel: MeasurementResultViewModel(measurementResult: viewModel.measurementResult!))
            } else {
                ProcessStateView()
            }
        }
        .animation(.easeInOut, value: viewModel.isShowMeasurementResultView)
        .onAppear { 
            viewModel.uploadAdjustedBodyLandmark(of: sharedProfileData.user, height: sharedProfileData.height,
                                                         gender: sharedProfileData.gender!,
                                                         clothingType: sharedProfileData.clothingType!)
            
//            viewModel.getLastMeasurementResults(of: sharedProfileData.user, measurementResults: $sharedProfileData.measurementResults)
        }
    }
    
}

#Preview {
    BodyLandmarkProcessView(viewModel: BodyLandmarkProcessViewModel(front: BodyLandmarkResponse.dummyBodyLandmarkResponse.front, side: BodyLandmarkResponse.dummyBodyLandmarkResponse.side))
        .environmentObject(SharedProfileData(gender: .male, clothingType: .jacket, user: .dummyUser))
}
