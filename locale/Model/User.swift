//
//  User.swift
//  locale
//
//  Created by Sachin Gala on 6/26/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Aadi Gala", email: "aadi.gala@icloud.com")
}
 
