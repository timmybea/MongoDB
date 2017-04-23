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
        
        getAPICalls()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: GET Methods
    var taskArray = [Task]()
    var categoryArray = [Category]()
    
    private func getAPICalls() {
        
        NetworkingManager.createTasks { (success, tasks) in
            if success {
                self.taskArray = tasks!

                print("task array has \(self.taskArray.count) entries")
                
                for task in self.taskArray {
                    print(task.id)
                    print(task.taskName)
                    print(task.isUrgent)
                }
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

}

