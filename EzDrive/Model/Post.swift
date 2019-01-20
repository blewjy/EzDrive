//
//  Post.swift
//  EzDrive
//
//  Created by Bryan Lew on 24/6/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

struct Post {
    var imageUrl: String
    var title: String
    var description: String
    var carModel: String
    var location: String
    var price: Double
    var timestamp: Double
    var licensePlateNo: String
    
    var uid: String
    
    var postId: String
    
    init(postId: String, uid: String, dictionary: [String: Any]) {
        
        self.postId = postId
        self.uid = uid
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        self.carModel = dictionary["carModel"] as? String ?? ""
        self.description = dictionary["description"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
        self.price = dictionary["price"] as? Double ?? 0
        self.licensePlateNo = dictionary["licensePlateNo"] as? String ?? ""

        self.timestamp = dictionary["timestamp"] as? Double ?? 0

    }
}
