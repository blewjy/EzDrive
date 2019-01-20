//
//  Message.swift
//  EzDrive
//
//  Created by Bryan Lew on 3/7/18.
//  Copyright © 2018 Bryan Lew. All rights reserved.
//

import UIKit

struct Message {
    var message: String
    var fromId: String
    var toId: String
    var timestamp: Double
    
    init(dictionary: [String: Any]) {
        self.message = dictionary["message"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Double ?? 0
    }
}
