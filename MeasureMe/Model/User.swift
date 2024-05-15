//
//  Login.swift
//  MeasureMe
//
//  Created by Diki Dwi Diro on 10/03/24.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

extension User {
    static var dummyUser: User = User(id: 42, name: "Diki Dwi Diro", email: "dikidwid0@gmail.com")
}

struct LoginResponse: Codable {
    let status: String
    let message: String
    let user: User
}
