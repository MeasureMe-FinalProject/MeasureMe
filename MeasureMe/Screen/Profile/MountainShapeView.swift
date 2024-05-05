//
//  MountainShapeView.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 04/05/24.
//

import SwiftUI

struct MountainShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start from the bottom left corner
        path.move(to: CGPoint(x: 0, y: rect.height))
        
        // Draw a line to the top left corner
        path.addLine(to: CGPoint(x: 0, y: rect.height / 4))
        
        // Draw a curve to the top center
        path.addQuadCurve(to: CGPoint(x: rect.width / 2, y: rect.height / 2.75),
                          control: CGPoint(x: rect.width / 2.5, y: rect.height / 7))
        
        // Draw a curve to the top right corner
        path.addQuadCurve(to: CGPoint(x: rect.width, y: rect.height / 4),
                          control: CGPoint(x: 2.5 * rect.width / 4, y: rect.height / 7)) // Modified control point
        
        // Draw a line to the bottom right corner
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        
        // Close the path
        path.closeSubpath()
        
        return path
    }
}
