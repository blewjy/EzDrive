//
//  Review.swift
//  EzDrive
//
//  Created by Bryan Lew on 19/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Review {
    var message: String
    var user: User
    var rating: Int
    var timestamp: Double
    
    init(message: String, rating: Int, user: User, timestamp: Double) {
        self.message = message
        self.rating = rating
        self.user = user
        self.timestamp = timestamp
    }
    
}
