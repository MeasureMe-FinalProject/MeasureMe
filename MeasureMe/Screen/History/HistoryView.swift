//
//  MyMeasureView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 25/02/24.
//

import SwiftUI

struct HistoryView: View {
    
    @StateObject var viewModel: HistoryViewModel = HistoryViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                createMeasurementResultList()
            }
            .scrollIndicators(.hidden)
            
            createNavigationBar()
        }
    }
    
    @ViewBuilder private func createMeasurementResultList() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(viewModel.measurementResultMonths.uniqued(), id: \.self) { month in
                Text("\(month)")
                    .font(.system(.title3, weight: .bold))
                
                ForEach(viewModel.dummyRecentResults) { result in
                    if month == viewModel.dateFormatter.string(from: result.date) {
                        HStack {
                            if viewModel.isShowRemoveButton {
                                createRemoveButton(result: result)
                            }
                            
                            MeasurementResultList(result: result)
                        }
                        
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 70)
        .padding([.horizontal, .bottom], 30)
    }
    
    @ViewBuilder private func createRemoveButton(result: Result) -> some View {
        Button {
            withAnimation {
                viewModel.remove(measurementResult: result, from: $viewModel.dummyRecentResults)
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
                    }
            }
            .ignoresSafeArea()
            .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    HistoryView()
}
