//
//  MeasurementResultListView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/05/24.
//

import SwiftUI

struct MeasurementResultListView: View {
    let result: RecentMeasurementResult
    
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
                        .fill(.blue)
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
    MeasurementResultListView(result: RecentMeasurementResult.dummyRecentMeasurementResult[0])
}
