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
                MeasurementResultView(viewModel: MeasurementResultViewModel(measurementResultResponse: viewModel.measurementResultResponse!))
            } else {
                ProcessStateView()
            }
        }
        .animation(.easeInOut, value: viewModel.isShowMeasurementResultView)
        .onAppear { viewModel.uploadAdjustedBodyLandmark(height: sharedProfileData.height!,
                                                         gender: sharedProfileData.gender!.codeName,
                                                         clothingType: sharedProfileData.clothingType!.codeName) }
    }
    
}

#Preview {
    BodyLandmarkProcessView(viewModel: BodyLandmarkProcessViewModel(front: BodyLandmarkResponse.dummyBodyLandmarkResponse.front, side: BodyLandmarkResponse.dummyBodyLandmarkResponse.side))
        .environmentObject(SharedProfileData(height: 160, gender: .male, clothingType: .LongPants, user: .dummyUser))
}
