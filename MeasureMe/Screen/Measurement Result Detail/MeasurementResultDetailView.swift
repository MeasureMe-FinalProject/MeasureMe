//
//  MeasurementResultDetailView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/04/24.
//

import SwiftUI

struct MeasurementResultDetailView: View {
    
    let measurementDetail: MeasurementDetail
    
    let twoGridColumns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack {
                Image(measurementDetail.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom)
                    .padding(.horizontal)
                    .frame(height: 300)
                
                Text(measurementDetail.name)
                    .font(.system(.title2, weight: .semibold))
                
                Text("The circle below represent each bodypart")
                    .font(.system(.caption, weight: .regular))
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
                
                LazyVGrid(columns: twoGridColumns) {
                    ForEach(measurementDetail.bodyParts) { bodyPart in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.blue.opacity(0.1))
                            .frame(width: 150, height: 110)
                            .shadow(radius: 10)
                            .overlay(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    Circle()
                                        .fill(bodyPart.color)
                                        .frame(width: 30, height: 30)
                                        .padding(.bottom, 5)
                                    
                                    Text(bodyPart.name)
                                        .font(.system(.headline))
                                    
                                    Text("\(String(format: "%.2f", bodyPart.length)) cm")
                                        .font(.system(.caption))
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                            }
                            .padding(.bottom)
                    }
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}


#Preview {
    MeasurementResultDetailView(measurementDetail: MeasurementDetail(name: "All Body Art", icon: "upper-body-icon", image: "general-body", bodyParts: BodyPart.allBodyParts))
}

