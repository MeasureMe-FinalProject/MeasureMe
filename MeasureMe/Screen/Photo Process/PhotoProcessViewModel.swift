//
//  PhotoProcessViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 28/02/24.
//

import SwiftUI

final class PhotoProcessViewModel: ObservableObject {
    @Published var bodyLandmarkResponse: BodyLandmarkResponse?
    @Published var isShowAdjustBodyLandmarkView: Bool = false
    @Published var isShowUndetectedBodyView: Bool = false
    
    func uploadCapturedImages(_ capturedImages: [UIImage]) {
        guard let frontImage = capturedImages.first,
              let sideImage = capturedImages.last else { return }
        
        NetworkManager.shared.upload(frontImage, and: sideImage) { [self] response, httpURLResponse in
            switch httpURLResponse.statusCode {
            case 200:
                DispatchQueue.main.async {[self] in
                    bodyLandmarkResponse = response
                    withAnimation {
                        isShowAdjustBodyLandmarkView = true
                    }
                }
                print("success")
            case 500:
                DispatchQueue.main.async {[self] in
                    withAnimation {
                        isShowUndetectedBodyView = true
                    }
                }
                print("fail")
            default:
                print("Unknown http status code")
            }
            
        }
    }
}
