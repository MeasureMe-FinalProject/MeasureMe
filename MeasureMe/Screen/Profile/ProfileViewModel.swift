//
//  ProfileViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 04/05/24.
//

import Foundation

final class ProfileViewModel: ObservableObject {
    @Published var isShowMoreInformation: Bool = false
    @Published var isShowLogOutAlert: Bool = false
    @Published var isShowLoginView: Bool = false
}
