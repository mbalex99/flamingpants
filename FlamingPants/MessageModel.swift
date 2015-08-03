//
//  File.swift
//  FlamingPants
//
//  Created by Maximilian Alexander on 7/24/15.
//  Copyright (c) 2015 Epoque. All rights reserved.
//

import Foundation
import Firebase

struct MessageModel {
    var messageId: String?
    var name: String
    var body: String
    
    init(snapshot: FDataSnapshot){
        messageId = snapshot.key
        name = snapshot.value["name"] as! String
        body = snapshot.value["body"] as! String
    }
    
    init(name: String, body: String){
        self.name = name
        self.body = body
    }
}