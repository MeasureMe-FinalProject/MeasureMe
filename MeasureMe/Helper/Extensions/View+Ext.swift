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
    
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
