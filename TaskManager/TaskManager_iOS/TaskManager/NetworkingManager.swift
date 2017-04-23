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
    private static func getCollection(_ collection: String, completion: @escaping(_ success: Bool, _ object: AnyObject?) -> ()) {
        
        let endpointURL = baseURL + "\(collection)?apiKey=\(apiKey)"
        
        let myURL = URL(string: endpointURL)
        
        let request = NSMutableURLRequest(url:myURL!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if (error != nil) {
                print(error?.localizedDescription ?? "get error")
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
        
        NetworkingManager.getCollection("tasks", completion: { (success, json) in
            
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
        
        NetworkingManager.getCollection("categories", completion: { (success, json) in
            
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
    
    //MARK: POST Request
    static func postDictionary(_ dictionary: [String: AnyObject], to collection: String, with completion: @escaping(_ success: Bool) -> ()) {
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []) {
            
            let endpointURLString = baseURL + "\(collection)?apiKey=\(apiKey)"
            let myURL = URL(string: endpointURLString)
            
            let request = NSMutableURLRequest(url: myURL!)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                
                if error != nil {
                    print(error?.localizedDescription ?? "post error")
                    completion(false)
                } else {
                    do {
                        if let data = data {
                            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                            print("POST DATA INCLUDES MONGO ID")
                            print(jsonData as Any)
                            completion(true)
                        }
                    } catch let error as NSError {
                        print(error)
                        completion(false)
                    }
                }
            }.resume()
            
        }
        
        //MARK: PUT Request (update item in collection)
    }
    
    

    
}

