//
//  View+Ext.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 02/03/24.
//

import SwiftUI

extension View {
    func getCurrentCGRect(from image: UIImage, in size: Binding<CGRect>) -> some View {
        modifier(SizeCalculator(image: image, size: size))
    }
}
