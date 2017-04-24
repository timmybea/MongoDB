//
//  Models.swift
//  TaskManager
//
//  Created by Tim Beals on 2017-04-23.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

struct Task {

    var id: String? //keep optional because this may only be created once you do a post request
    var taskName: String!
    var category: String!
    var dueDate: String!
    var isUrgent: Bool!
    
    func taskAsDictionary() -> [String: AnyObject]{
        var dictionary = [String: AnyObject]()
        dictionary["id"] = id as AnyObject?
        dictionary["task_name"] = taskName as AnyObject?
        dictionary["due_date"] = dueDate as AnyObject?
        dictionary["isUrgent"] = isUrgent as AnyObject?
        dictionary["category"] = category as AnyObject?
        return dictionary
    }
    
}


struct Category {
    
    let id: String!
    var categoryName: String!
}
