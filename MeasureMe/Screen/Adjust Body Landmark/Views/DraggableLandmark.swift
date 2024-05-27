//
//  DraggableLandmark.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 15/05/24.
//

import SwiftUI

struct DraggableLandmark: View {
    
    let bodyLandmark: BodyLandmark
    var onChanged: ((CGSize, BodyLandmark) -> Void)?
    @State private var dragAmount: CGSize = .zero
    private var isTopBodyLandmark: Bool { bodyLandmark.landmark == .top }
    private var isBottomBodyLandmark: Bool { bodyLandmark.landmark == .bot }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { newValue in
                dragAmount = newValue.translation
                onChanged?(dragAmount, bodyLandmark)
                print(dragAmount)
            }
            .onEnded { _ in
                withAnimation {
                    onChanged?(dragAmount, bodyLandmark)
                    dragAmount = .zero
                }
            }
    }
    
    var body: some View {
        ZStack {
            Text(bodyLandmark.landmark.name)
                .font(.system(.caption2, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 5)
                .padding(.vertical, 2.5)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.appPrimary)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 1.5).fill(.white)
                        }
                }
                .opacity(isTopBodyLandmark || isBottomBodyLandmark ? 1 : 0)
                .offset(y: isTopBodyLandmark ? -15 : isBottomBodyLandmark ? 15 : 0)
            
            Circle()
                .fill(.appPrimary)
                .frame(width: 10, height: 10)
        }
        .offset(dragAmount)
        .gesture(dragGesture)
    }
}

#Preview {
    DraggableLandmark(bodyLandmark: BodyLandmark(landmark: .top, coordinate: .zero))
}
