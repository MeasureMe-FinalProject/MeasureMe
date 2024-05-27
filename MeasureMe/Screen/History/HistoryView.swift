//
//  MyMeasureView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 25/02/24.
//

import SwiftUI

struct HistoryView: View {
    
    @StateObject var viewModel: HistoryViewModel = HistoryViewModel()
    @EnvironmentObject var sharedProfileData: SharedProfileData
    
    var body: some View {
        ZStack(alignment: .top) {
            if let measurementResults = sharedProfileData.getAllMeasurementResults() {
                createMeasurementResultList(measurementResultMonths: measurementResults.months,
                                            recentMeasurementResults: measurementResults.results)
            } else {
               createEmptyStateView()
            }
            createNavigationBar()
        }
        .alert("Delete Measurement", isPresented: $viewModel.isShowAlertMessage, presenting: viewModel.alertItem) { alertItem in
            Button("OK") {
                viewModel.alertItem = nil
                viewModel.isShowAlertMessage.toggle()
            }
        } message: { alertItem in
            Text("\(alertItem.message)")
        }
        .fullScreenCover(item: $viewModel.selectedMeasurementResult) { measurementResult in
            MeasurementResultView(viewModel: MeasurementResultViewModel(measurementResult: measurementResult))
        }
    }
    
    @ViewBuilder private func createEmptyStateView() -> some View {
        EmptyStateView()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    
    @ViewBuilder private func createMeasurementResultList(measurementResultMonths: [String], 
                                                          recentMeasurementResults: [MeasurementResult]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(measurementResultMonths.uniqued(), id: \.self) { month in
                    Text("\(month)")
                        .font(.system(.title3, weight: .bold))
                    
                    ForEach(recentMeasurementResults) { result in
                        if month == sharedProfileData.getMonth(from: result.date) {
                            HStack {
                                if viewModel.isShowRemoveButton {
                                    createRemoveButton(result: result)
                                }
                                
                                MeasurementResultListView(result: result)
                                    .onTapGesture {
                                        viewModel.selectedMeasurementResult = result
                                    }
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
    
    @ViewBuilder private func createRemoveButton(result: MeasurementResult) -> some View {
        Button {
            #warning("It has to be one source of truth")
            withAnimation {
                sharedProfileData.remove(measurementResult: result, completed: viewModel.showPopUpAlert)
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
                        .opacity(sharedProfileData.measurementResults != nil ? 1 : 0)
                    }
            }
            .ignoresSafeArea()
            .frame(maxHeight: .infinity, alignment: .top)
        
    }
}

#Preview {
    HistoryView()
        .environmentObject(SharedProfileData(user: .dummyUser, measurementResults: MeasurementResult.dummyRecentMeasurementResult))
}
