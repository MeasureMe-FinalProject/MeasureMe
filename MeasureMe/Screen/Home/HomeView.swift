//
//  HomeView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 21/02/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Image(.headerLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 45)
            
            ScrollView {
                createNavBarButtons()
                
                createStartMeasurementButton()
                
                createSizeRecommendationOptions()
                
                createRecentMeasurementResults()
            }
            .scrollIndicators(.hidden)
        }
        .fullScreenCover(isPresented: $viewModel.isShowNewMeasurementView)  {
            NewMeasurementView(isShow: $viewModel.isShowNewMeasurementView)
        }
    }
    
    @ViewBuilder private func createNavBarButtons() -> some View {
        HStack(alignment: .center, spacing: 15) {
            Image(.profile)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background {
                    RoundedRectangle(cornerRadius: 70)
                        .fill(.secondary)
                }
                .frame(width: 40, height: 40)
            
            Group {
                Text("Hello, ")
                +
                Text("\(viewModel.fullName)!")
                    .fontWeight(.semibold)
            }
            .font(.system(.body))
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "bell.badge")
                    .symbolRenderingMode(.multicolor)
                    .imageScale(.large)
            }
            
        }
        .padding(.horizontal, 30)
        .padding(.vertical)
    }
    
    @ViewBuilder private func createStartMeasurementButton()-> some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: 1.5)
            .fill(.blue)
            .shadow(color: .blue, radius: 10)
            .overlay {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Measurement 📐")
                        .font(.system(.headline, weight: .medium))
                    
                    Text("Let's find your body measurement!")
                        .font(.system(.caption2))
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 5)
                    
                    Button {
                        viewModel.isShowNewMeasurementView.toggle()
                    } label: {
                        Text("Start Measurement")
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
    }
    
    @ViewBuilder private func createSizeRecommendationOptions() -> some View {
        VStack(alignment: .leading) {
            Text("Size Recommendation")
                .font(.system(.title3, weight: .semibold))
            
            Text("Get your clothes size recommendation")
                .font(.system(.footnote))
                .foregroundStyle(.secondary)
                .padding(.bottom, 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 30)
        
        ScrollView(.horizontal) {
            HStack(spacing: 7.5) {
                Spacer().frame(width: 20)
                ForEach(ClothingType.allCases, id: \.self) { clothing in
                    createClothingType(of: clothing)
                }
                Spacer().frame(width: 20)
            }
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity)
        .padding(.bottom)
    }
    
    @ViewBuilder private func createRecentMeasurementResults() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Recent Measurement")
                .font(.system(.title3, weight: .semibold))
            
            ForEach(viewModel.dummyRecentResults) { result in
                MeasurementResult(result: result)
            }
        }
        .frame(maxWidth: .infinity)
        .padding([.horizontal, .bottom], 30)
    }
    
    @ViewBuilder private func createClothingType(of clothing: ClothingType) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: 2)
            .fill(.primary.opacity(0.1))
            .shadow(color: .primary.opacity(0.1), radius: 4)
            .overlay {
                VStack(spacing: 10){
                    Text(clothing.icon)
                        .font(.system(size: 70))
                        .shadow(color: .primary.opacity(0.25), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    
                    Text(clothing.name)
                        .font(.system(.caption, weight: .semibold))
                }
            }
            .frame(width: 95, height: 170)
            .padding(.all, 2)
    }
}

#Preview {
    HomeView()
}

struct MeasurementResult: View {
    let result: Result
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "dd-MM-YYYY, HH:mm"
        return formatter
    }()
    private var formattedDate: String {
        dateFormatter.string(from: result.date)
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: 1)
            .fill(.primary.opacity(0.20))
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.blue)
                        .offset(y: 6)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.background)
                }
            }
            .overlay {
                HStack(spacing: 15) {
                    Text(result.icon)
                        .font(.system(size: 30))
                    
                    VStack(alignment: .leading) {
                        Text(result.name)
                            .font(.system(.subheadline))
                        
                        Text(formattedDate)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 70)
    }
}
