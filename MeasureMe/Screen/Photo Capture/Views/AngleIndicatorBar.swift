//
//  AngleIndicatorBar.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 15/05/24.
//

import SwiftUI

struct AngleIndicatorBar: View {
    
    @ObservedObject var viewModel: PhotoCaptureViewModel
    var barGradientColor : RadialGradient {
        RadialGradient(colors: [.red, .green],
                       center: .center,
                       startRadius: 36,
                       endRadius: 22)
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(barGradientColor)
            .frame(width: 24, height: 216)
            .overlay {
                ZStack {
                    VStack(spacing: 20) {
                        ForEach(0..<9) {_ in
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.white)
                                .frame(width: 16, height: 1.5)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "arrowtriangle.right.fill")
                            .foregroundStyle(viewModel.isOnPosition ? .green : .red)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.primary)
                            .frame(width: 18, height: 2)
                        
                        Image(systemName: "arrowtriangle.left.fill")
                            .foregroundStyle(viewModel.isOnPosition ? .green : .red)
                        
                    }
                    .offset(y: viewModel.yPositionIndicator)
                }
            }
            .offset(x: viewModel.isOnPosition ? 150 : 0)
    }
}


#Preview {
    AngleIndicatorBar(viewModel: PhotoCaptureViewModel())
}
