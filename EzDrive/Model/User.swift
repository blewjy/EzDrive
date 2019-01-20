//
//  User.swift
//  EzDrive
//
//  Created by Bryan Lew on 25/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

struct User {
    var name: String
    var email: String
    var handle: String
    var uid: String
    var profileImageUrl: String
    var location: String
    var memberSince: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.handle = dictionary["handle"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.memberSince = dictionary["memberSince"] as? String ?? ""

    }
    
}
