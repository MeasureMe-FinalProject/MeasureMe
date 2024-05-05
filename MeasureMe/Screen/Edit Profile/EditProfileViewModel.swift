//
//  EditProfileViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 04/05/24.
//

import SwiftUI
import PhotosUI

final class EditProfileViewModel: ObservableObject {
    @Published var imageItem: PhotosPickerItem?
    @Published var image: Image?
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var dateOfBirth: Date = Date()
    
    @Published var selectedGender: GenderType?
    @Published var height: Int = 166
    
    @Published var isShowSuccessAlert: Bool = false
    
    var paddingHeightImageVector: CGFloat {
        if height <= 0 {
            return 500
        }else if height <= 25 {
            return 150
        } else if height <= 50 {
            return 100
        } else if height <= 100  {
            return 75
        } else if height <= 150 {
            return 50
        } else if height <= 175{
            return 25
        } else {
            return 0
        }
    }
}
