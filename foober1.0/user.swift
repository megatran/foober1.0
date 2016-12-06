//
//  user.swift
//  foober1.0
//
//  Created by Amos Gwa on 12/5/16.
//  Copyright © 2016 Colorado School of Mines. All rights reserved.
//

import Foundation

class user {
    var id = UUID().uuidString
    var username : String = ""
    var password : String = ""
    var orders : [String: AnyObject] = [:]
    
    func printUser() {
        print("username : \(username), password : \(password), orders : \(orders)")
    }
}
