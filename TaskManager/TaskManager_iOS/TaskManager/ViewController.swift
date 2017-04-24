//
//  ViewController.swift
//  TaskManager
//
//  Created by Tim Beals on 2017-04-23.
//  Copyright © 2017 Tim Beals. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.gray
        
        getRequests()
        postJSON()
        removeRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: GET Requests
    var taskArray = [Task]()
    var categoryArray = [Category]()
    
    
    private func getRequests() {
        
        NetworkingManager.createTasks { (success, tasks) in
            if success {
                self.taskArray = tasks!

                print("task array has \(self.taskArray.count) entries")
                
                for task in self.taskArray {
                    print(task.id ?? "no id")
                    print(task.taskName)
                    print(task.isUrgent)
                }
                //self.putJSON() >>> update an item in the database after it has been downloaded and instantiated locally
            }
        }
        
        NetworkingManager.createCategories { (success, categories) in
            if success {
                self.categoryArray = categories!
                
                print("category array has \(self.categoryArray.count) entries")
                
                for category in self.categoryArray {
                    print(category.id)
                    print(category.categoryName)
                }
            }
        }
    }
    
    //MARK: POST requests

    private func postJSON() {
        
        var newTask = Task(id: nil, taskName: "shopping", category: "home", dueDate: "2017-04-28", isUrgent: true)

        let taskDictionary = newTask.taskAsDictionary()
        
        NetworkingManager.postDictionary(taskDictionary as [String : AnyObject], to: "tasks") { (success, id) in
            if success {
                //once the task has been posted add the id assigned by the database
                newTask.id = id
                print(newTask)
            }
        }
    }
    
    //MARK: PUT requests
    
    private func putJSON() {
        
        var dictionary = [String: AnyObject]()
        
        if var task = self.taskArray.first {
            task.taskName = "Wowza"
            dictionary = task.taskAsDictionary()
        }
        
        NetworkingManager.putDictionary(dictionary, in: "tasks") { (success) in
            print("item was updated")
        }
    }
    
    //MARK: REMOVE request 
    
    private func removeRequest() {
        
        NetworkingManager.deleteItem("58fbed0ac2ef162ad30b569c", from: "tasks") { (success) in
            if success {
                print("item was deleted. You would now deinit the local instance")
            }
        }
        
    }
}

