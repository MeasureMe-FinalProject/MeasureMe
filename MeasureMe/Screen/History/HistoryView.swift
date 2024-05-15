//
//  MyMeasureView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 25/02/24.
//

import SwiftUI

struct HistoryView: View {
    
    @ObservedObject var viewModel: HistoryViewModel
    @EnvironmentObject var sharedProfileData: SharedProfileData
    
    var body: some View {
        ZStack(alignment: .top) {
            if let measurementResultMonths = viewModel.measurementResultMonths,
               let recentMeasurementResults = viewModel.recentMeasurementResults,
               !measurementResultMonths.isEmpty && !recentMeasurementResults.isEmpty {
                createMeasurementResultList(measurementResultMonths: measurementResultMonths,
                                            recentMeasurementResults: recentMeasurementResults)
            } else {
               createEmptyStateView()
            }
            createNavigationBar()
        }
    }
    
    @ViewBuilder private func createEmptyStateView() -> some View {
        EmptyStateView()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    
    @ViewBuilder private func createMeasurementResultList(measurementResultMonths: [String], 
                                                          recentMeasurementResults: [RecentMeasurementResult]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(measurementResultMonths.uniqued(), id: \.self) { month in
                    Text("\(month)")
                        .font(.system(.title3, weight: .bold))
                        .onAppear {
                            print(month)
                        }
                    
                    ForEach(recentMeasurementResults) { result in
                        if month == viewModel.getMonth(from: result.date) {
                            HStack {
                                if viewModel.isShowRemoveButton {
                                    createRemoveButton(result: result)
                                }
                                
                                MeasurementResultListView(result: result)
                                    .onAppear(perform: {
                                        print(month)
                                    })
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 70)
            .padding([.horizontal, .bottom], 30)
        }
    }
    
    @ViewBuilder private func createRemoveButton(result: RecentMeasurementResult) -> some View {
        Button {
#warning("It has to be one source of truth")
            withAnimation {
                if let _ = viewModel.recentMeasurementResults {
                    viewModel.remove(measurementResult: result)
                }
            }
        } label: {
            Image(systemName: "minus.circle.fill")
                .symbolRenderingMode(.multicolor)
                .font(.system(.title3, weight: .semibold))
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder private func createNavigationBar() -> some View {
         
        Rectangle()
            .foregroundStyle(.background)
            .shadow(color: .black.opacity(0.075), radius: 3, y: 4)
            .frame(height: 100)
            .overlay(alignment: .bottom) {
                Text("History")
                    .font(.system(.body, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
                    .overlay(alignment: .trailing) {
                        if let measurementResultMonths = viewModel.measurementResultMonths,
                           let recentMeasurementResults = viewModel.recentMeasurementResults,
                           !measurementResultMonths.isEmpty && !recentMeasurementResults.isEmpty {
                            Button {
                                withAnimation {
                                    viewModel.isShowRemoveButton.toggle()
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .font(.system(.headline, weight: .semibold))
                                    .foregroundStyle(.red)
                            }
                            .padding(.trailing, 30)
                            .padding(.bottom)
                        }
                    }
            }
            .ignoresSafeArea()
            .frame(maxHeight: .infinity, alignment: .top)
            
    }
}

#Preview {
    HistoryView(viewModel: HistoryViewModel(measurementResults: RecentMeasurementResult.dummyRecentMeasurementResult))
        .environmentObject(SharedProfileData(user: .dummyUser))
}
