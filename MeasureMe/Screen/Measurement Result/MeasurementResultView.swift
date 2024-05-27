//
//  MeasurementResultView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/04/24.
//

import SwiftUI

struct MeasurementResultView: View {
    
    @ObservedObject var viewModel: MeasurementResultViewModel
    @EnvironmentObject var sharedProfileData: SharedProfileData
    @Environment(\.dismiss) var dismiss
    
    var measurementResultShareView: some View {
            VStack {
                Image(.headerLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .padding(.bottom)
                
                createDateAndMeasurementName()
                
                createRecommendedClothingSize()
                                
                createMeasurementDetails()
                
                MeasurementResultDetailView(measurementDetail: viewModel.measurementDetail)                
            }
            .frame(height: 1500)
            .background(.white)
            .padding(.horizontal)
            .padding(.bottom, 30)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                createDateAndMeasurementName()
                
                createRecommendedClothingSize()
                                
                createMeasurementDetails()
                
                createSeeMoreButton()
                
                createDoneButton()
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal)
            .onDisappear {
                viewModel.updateMeasurementResults(measurementResults: $sharedProfileData.measurementResults,
                                                   of: sharedProfileData.user)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if let image = viewModel.measurementResultImage {
                        ShareLink(item: image, preview: SharePreview("Measurement Result", image: image)) {
                            Image(systemName: "square.and.arrow.up")
                                .padding(.trailing)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowMeasurementDetailView) {
            if #available(iOS 16.4, *) {
                MeasurementResultDetailView(measurementDetail: viewModel.measurementDetail)
                    .padding()
                    .ignoresSafeArea()
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(25)
                    .presentationDetents([.height(580)])
            } else {
                MeasurementResultDetailView(measurementDetail: viewModel.measurementDetail)
                    .padding()
                    .ignoresSafeArea()
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.height(580)])
            }
            
        }
        .onAppear {
            DispatchQueue.main.async {
                let image = measurementResultShareView.snapshot()
                viewModel.measurementResultImage = Image(uiImage: image)
                
            }
        }
    }
    
    @ViewBuilder func createDateAndMeasurementName() -> some View {
        VStack(spacing: 5) {
            Text("Measurement Result")
                .font(.system(.title3, weight: .semibold))
            
            Text(viewModel.measurementResult.date)
                .font(.system(.caption))
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder func createRecommendedClothingSize() -> some View {
        VStack(alignment: .center, spacing: 5) {
            Text(viewModel.measurementResultIcon)
                .font(.system(size: 160))
                .padding(.top)
            
            Text(viewModel.measurementResult.clothingType)
                .font(.system(.title, weight: .bold))

            Text("Your Recommended Size")
                .font(.system(.caption))
                .foregroundStyle(.secondary)
                .padding(.bottom, 10)
            
            Text(viewModel.sizeRecommendation)
                .font(.system(.largeTitle, weight: .heavy))
                .foregroundStyle(.white)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.appPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.bottom)
            
        }
        .shadow(color: .primary.opacity(0.3),radius: 10)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical)
    }
    
    @ViewBuilder func createMeasurementDetails() -> some View {
        VStack {
            Text("Measurement Detail")
                .font(.system(.title3, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .top])
            
            List {
                HStack {
                    Text("Gender")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text(viewModel.measurementResult.gender)
                    
                }
                
                HStack {
                    Text("Height")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(viewModel.measurementResult.height)) cm")
                    
                }
            }
            .scrollDisabled(true)
            .listStyle(.plain)
            .frame(height: 100)
        }
    }
    
    @ViewBuilder func createSeeMoreButton() -> some View {
        Button {
            viewModel.isShowMeasurementDetailView.toggle()
        } label: {
            Text("See More")
                .font(.system(.callout))
                .fontWeight(.medium)
        }
        .padding(.leading)
        .padding(.bottom)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    @ViewBuilder func createDoneButton() -> some View {
        Button {
            viewModel.doneButtonTapped(dismiss: dismiss, isMeasurementFinished: $sharedProfileData.isMeasurementFinished)
        } label: {
            Text("Done")
                .foregroundStyle(.white)
                .font(.system(.subheadline, weight: .semibold))
                .frame(height: 44)
                .frame(maxWidth: .infinity, maxHeight: 44)
                .background(Color.appPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal)
        .padding(.top, 28)
    }
}

#Preview {
    MeasurementResultView(viewModel: MeasurementResultViewModel(measurementResult: .dummyRecentMeasurementResult![0]))
        
}
