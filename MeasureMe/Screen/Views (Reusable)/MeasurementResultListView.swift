//
//  MeasurementResultListView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/05/24.
//

import SwiftUI

struct MeasurementResultListView: View {
    let result: MeasurementResult
    
    var icon: String {
        switch result.clothingType.capitalized {
        case "T-Shirt":
            "👕"
        case "Long Pants":
            "👖"
        case "Jacket":
            "🧥"
        case "Short Pants":
            "🩳"
        default:
            ""
        }
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: 1)
            .fill(.primary.opacity(0.20))
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.appPrimary)
                        .offset(y: 6)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.background)
                }
            }
            .overlay {
                HStack(spacing: 15) {
                    Text(icon)
                        .font(.system(size: 30))
                    
                    VStack(alignment: .leading) {
                        Text("Size Recommendation")
                            .font(.system(.subheadline))
                        
                        Text(result.date)
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


#Preview {
    MeasurementResultListView(result:MeasurementResult(id: 1,
                                                       idUser: 23,
                                                       date: "01-09-2024, 20:30",
                                                       clothingType: "Short Pants",
                                                       gender: "Male",
                                                       sizeRecommendation: "S",
                                                       height: 163,
                                                       bustCircumference: 160,
                                                       waistCircumference: 20,
                                                       hipCircumference: 20,
                                                       shoulderWidth: 30,
                                                       sleeveLength: 40,
                                                       pantsLength: 40))
}
