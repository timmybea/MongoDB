//
//  NetworkingManager.swift
//  TaskManager
//
//  Created by Tim Beals on 2017-04-23.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class NetworkingManager: NSObject {
    
    private static let apiKey = "i80KEmnblwF6PPTw_T5QHtQGXFpU8cT_"
    private static let baseURL = "https://api.mlab.com/api/1/databases/taskmanager/collections/"
    
    
    //MARK: GET Request (an internal function)
    private static func getCollection(name: String, completion: @escaping(_ success: Bool, _ object: AnyObject?) -> ()) {
        
        let endpointURL = baseURL + "\(name)?apiKey=\(apiKey)"
        
        let myURL = URL(string: endpointURL);
        
        let request = NSMutableURLRequest(url:myURL!);
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if (error != nil) {
                print(error?.localizedDescription ?? "error")
                completion(false, nil)
            } else {
                do {
                    if let data = data {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        completion(true, json as AnyObject)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(false, nil)
                }
            }
        }.resume()
    }
    
    
    static func createTasks(with completion: @escaping(_ success: Bool, _ tasks: [Task]?) -> ()) {
        
        NetworkingManager.getCollection(name: "tasks", completion: { (success, json) in
            
            if success {
                var taskArray = [Task]()
                
                if let jsonTasks = json as? [[String: AnyObject]] {
    
                    for task in jsonTasks {
                        
                        let idDict = task["_id"] as! [String: AnyObject]
                        let id = idDict["$oid"] as! String
                        let taskName = task["task_name"] as! String
                        let category = task["category"] as! String
                        let dueDate = task["due_date"] as! String
                        let isUrgent = task["isUrgent"] as! Bool
                        
                        let newTask = Task(id: id, taskName: taskName, category: category, dueDate: dueDate, isUrgent: isUrgent)
                        
                        taskArray.append(newTask)
                    }
                    
                    DispatchQueue.main.async {
                        completion(true, taskArray)
                    }
                }
            } else {
                completion(false, nil)
            }
        })
    }
    
    
    static func createCategories(with completion: @escaping(_ success: Bool, _ tasks: [Category]?) -> ()) {
        
        NetworkingManager.getCollection(name: "categories", completion: { (success, json) in
            
            if success {
                var categoryArray = [Category]()
                
                if let jsonCategories = json as? [[String: AnyObject]] {
                    
                    for category in jsonCategories {
                        
                        let idDict = category["_id"] as! [String: AnyObject]
                        let id = idDict["$oid"] as! String
                        let categoryName = category["category_name"] as! String
                        
                        let newCategory = Category(id: id, categoryName: categoryName)
                        
                        categoryArray.append(newCategory)
                    }
                    
                    DispatchQueue.main.async {
                        completion(true, categoryArray)
                    }
                }
            } else {
                completion(false, nil)
            }
        })
    }
    
    //POST Request
    

    
}

