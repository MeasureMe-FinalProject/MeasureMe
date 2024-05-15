//
//  HomeView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 21/02/24.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var sharedProfileData: SharedProfileData
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack {
                Image(.headerLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 45)
                    .padding(.vertical, 5)
                    .padding(.bottom, 10)
                
                ScrollView {
                    VStack {
                        createNavBarButtons()
                        
                        createSizeRecommendationOptions()
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 60)
                    .background(RoundedRectangle(cornerRadius: 32).fill(.blue))
                    
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.white)
                        .overlay(alignment: .top) {
                            VStack {
                                createStartMeasurementButton()
                                createRecentMeasurementResults()
                            }
                        }
                        .frame(height: 450)
                        .offset(y: -65)
                }
                .scrollBounceBehavior(.automatic)
                .scrollClipDisabled()
                .scrollIndicators(.hidden)
            }
            .fullScreenCover(isPresented: $sharedProfileData.isMeasurementFinished)  {
                NewMeasurementView(isShow: $sharedProfileData.isMeasurementFinished)
            }
        }
    }
    
    @ViewBuilder private func createNavBarButtons() -> some View {
        HStack(alignment: .center, spacing: 15) {
            Image("profile-image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background {
                    RoundedRectangle(cornerRadius: 70)
                        .fill(.black)
                }
                .frame(width: 40, height: 40)
            
            Group {
                Text("Hello, ")
                +
                Text("\(sharedProfileData.user.name)!")
                    .fontWeight(.semibold)
            }
            .font(.system(.body))
            
            Spacer()
            

        }
        .foregroundStyle(.white)
        .padding(.horizontal, 30)
        .padding(.vertical)
    }
    
    @ViewBuilder private func createStartMeasurementButton()-> some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(lineWidth: 0.75)
            .fill(.blue)
            .background(RoundedRectangle(cornerRadius: 12).fill(.white))
            .shadow(color: .blue.opacity(0.2), radius: 10)
            .overlay {
                VStack(alignment: .leading, spacing: 5) {
                    Text("AR Ruler 📐")
                        .font(.system(.headline, weight: .medium))
                    
                    Text("Let's measure your items quickly!")
                        .font(.system(.caption2))
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 5)
                    
                    Button {
                        viewModel.isShowNewMeasurementView.toggle()
                    } label: {
                        Text("Start Measure")
                            .foregroundStyle(.background)
                            .font(.system(.subheadline, weight: .semibold))
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 44)
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 7.5))
                    }
                }
                .padding(.all)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .padding(.horizontal, 30)
            .padding(.bottom)
            .padding(.top, 32)
    }
    
    @ViewBuilder private func createSizeRecommendationOptions() -> some View {
        VStack(alignment: .leading) {
            Text("Size Recommendation ✨")
                .font(.system(.title3, weight: .semibold))
            
            Text("Get your clothes size recommendation")
                .font(.system(.footnote))
                .foregroundStyle(.secondary)
                .padding(.bottom, 5)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 30)
        
        ScrollView(.horizontal) {
            HStack(spacing: 12.5) {
                Spacer().frame(width: 20)
                ForEach(ClothingType.allCases, id: \.self) { clothing in
                    Button {
                        sharedProfileData.clothingType = clothing
                        viewModel.isShowNewMeasurementView = true
                        sharedProfileData.isMeasurementFinished = true
                    } label: {
                        createClothingType(of: clothing)
                    }
                    .accessibilityIdentifier(clothing == .tShirt ? "tShirt" : "")
                }
                Spacer().frame(width: 20)
            }
        }
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity)
        .padding(.bottom)
    }
    
    @ViewBuilder private func createRecentMeasurementResults() -> some View {
        VStack(spacing: 20) {
            Text("Recent Measurement")
                .font(.system(.title3, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let measurementResults = viewModel.recentMeasurementResults,
               !measurementResults.isEmpty {
                ForEach(measurementResults) { result in
                    MeasurementResultListView(result: result)
                }
            } else {
                Text("No recent measurement results")
                    .font(.system(.body))
                    .foregroundStyle(.secondary)
                    .padding(.vertical)
                    
            }
        }
        .frame(maxWidth: .infinity)
        .padding([.horizontal, .bottom], 30)
    }
    
    @ViewBuilder func createClothingType(of clothing: ClothingType) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(lineWidth: 2)
            .fill(.primary.opacity(0.1))
            .background(RoundedRectangle(cornerRadius: 12).fill(.white))
            .shadow(color: .primary.opacity(0.25), radius: 10)
            .overlay {
                VStack(spacing: 10){
                    Text(clothing.icon)
                        .font(.system(size: 70))
                    
                    Text(clothing.name)
                        .font(.system(.caption, weight: .semibold))
                }
            }
            .shadow(color: .primary.opacity(0.25), radius: 5)
            .frame(width: 95, height: 165)
            .padding(.all, 2)
            .tint(.black)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(recentMeasurementResults: RecentMeasurementResult.dummyRecentMeasurementResult))
        .environmentObject(SharedProfileData(clothingType: .LongPants, user: User.dummyUser))
}

