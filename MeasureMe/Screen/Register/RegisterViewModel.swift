//
//  RegisterViewModel.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 08/03/24.
//

import Foundation

final class RegisterViewModel: ObservableObject {
    @Published var isSignIn: Bool = false
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
}
