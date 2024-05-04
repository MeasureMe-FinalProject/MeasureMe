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
    let password: String
}

extension User {
    static var dummyUser: User = User(id: 1, name: "Diki Dwi Diro", email: "dikidwid0@gmail.com", password: "adadeh")
}
