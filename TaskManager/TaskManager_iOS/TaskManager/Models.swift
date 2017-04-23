//
//  Models.swift
//  TaskManager
//
//  Created by Tim Beals on 2017-04-23.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

struct Task {

    let id: String!
    let taskName: String!
    let category: String!
    let dueDate: String!
    let isUrgent: Bool!
}


struct Category {
    
    let id: String!
    let categoryName: String!
}

//{
//    "_id": {
//        "$oid": "58f90e67734d1d3bdb4106b9"
//    },
//    "category_name": "work"
//}
