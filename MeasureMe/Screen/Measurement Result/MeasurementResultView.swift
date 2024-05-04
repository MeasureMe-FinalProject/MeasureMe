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
                
                createCloseButton()
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal)
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
                MeasurementResultDetailView(measurementDetail: viewModel.measurementDetail)
                    .padding()
                    .ignoresSafeArea()
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(25)
                    .presentationDetents([.height(580)])
            
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
            Text("My Measure")
                .font(.system(.title3, weight: .semibold))
            
            Text(viewModel.formattedDate)
                .font(.system(.caption))
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder func createRecommendedClothingSize() -> some View {
        VStack(alignment: .center, spacing: 5) {
            Text(sharedProfileData.clothingType!.icon)
                .font(.system(size: 160))
                .padding(.top)
            
            Text(sharedProfileData.clothingType!.name)
                .font(.system(.title, weight: .bold))

            Text("Your Recommended Size")
                .font(.system(.caption))
                .foregroundStyle(.secondary)
                .padding(.bottom, 10)
            
            Text(viewModel.sizeRecommendation)
                .font(.system(.largeTitle, weight: .heavy))
                .foregroundStyle(.background)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.bottom)
            
        }
        .shadow(radius: 10)
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
                    
                    Text(sharedProfileData.gender!.name)
                    
                }
                
                HStack {
                    Text("Height")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(sharedProfileData.height!) cm")
                    
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
    
    @ViewBuilder func createCloseButton() -> some View {
        Button {

        } label: {
            Text("Done")
                .foregroundStyle(.background)
                .font(.system(.subheadline, weight: .semibold))
                .frame(height: 44)
                .frame(maxWidth: .infinity, maxHeight: 44)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal)
        .padding(.top, 28)
    }
}

#Preview {
    MeasurementResultView(viewModel: MeasurementResultViewModel(measurementResultResponse: MeasurementResultResponse.dummyMeasurementResultResponse))
        .environmentObject(SharedProfileData(height: 169, gender: .male, clothingType: .LongPants, user: .dummyUser))
}
