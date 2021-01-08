//
//  User.swift
//  Cheapskate
//
//  Created by Ashwin Chitoor on 1/7/21.
//

import Foundation

struct User {
    
    var firstName = String()
    var lastName = String()
    var email = String()
    var groupId = String()
    var uid = String()
    var receipt = [String: Int]()
    var group: [String] = []
    
    init() {}
}

var user = User()


