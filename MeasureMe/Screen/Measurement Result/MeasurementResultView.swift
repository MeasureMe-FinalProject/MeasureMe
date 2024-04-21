//
//  MeasurementResultView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/04/24.
//

import SwiftUI

struct MeasurementResultView: View {
    
    @ObservedObject var viewModel: MeasurementResultViewModel
    
    var body: some View {
        VStack {
            Text("My Measure")
                .font(.system(.title3, weight: .semibold))
                
            Text(viewModel.formattedDate)
                .font(.system(.caption))
                .foregroundStyle(.secondary)
                .padding(.bottom, 5)
            
            Text("Long Pants")
                .font(.system(.footnote, weight: .semibold))
                .foregroundStyle(.background)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Spacer()
            
            VStack(spacing: 5) {
                Text("👖")
                    .font(.system(size: 160))
                
                Text("Recommended Size")
                    .font(.system(.callout))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 10)
                
                Text("M")
                    .font(.system(.title, weight: .heavy))
                    .foregroundStyle(.background)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .shadow(radius: 10)
            
            Spacer()
            
            Text("Measurement details")
                .font(.system(.caption))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            VStack(spacing: 12) {

                ForEach(viewModel.measurementDetails) {
                measurementDetail in
                    Button {
                        viewModel.selectedDetail = measurementDetail
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 1.5)
                            .fill(.secondary)
                            .frame(height: 55)
                            .overlay {
                                HStack {
                                    Label {
                                        Text(measurementDetail.name)
                                            .foregroundStyle(.black)
                                        
                                    } icon: {
                                        Image(measurementDetail.icon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                            }
                    }
                    .tint(.blue)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .sheet(item: $viewModel.selectedDetail) { measurementDetail in
            MeasurementResultDetailView(measurementDetail: measurementDetail)
                .padding()
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(25)
                .presentationDetents([.height(550)])
        }
    }
}

#Preview {
    MeasurementResultView(viewModel: MeasurementResultViewModel(measurementDetails: [
        MeasurementDetail(name: "General Body",
                          icon: "general-body-icon",
                          image: "general-body",
                          bodyParts: BodyPart.generalBodypart),
        
        MeasurementDetail(name: "Upper Body",
                          icon: "upper-body-icon",
                          image: "upper-body",
                          bodyParts: BodyPart.upperBodyParts),
        
        MeasurementDetail(name: "Lower Body",
                          icon: "lower-body-icon",
                          image: "lower-body",
                          bodyParts: BodyPart.lowerBodyParts)
    ]))
}
