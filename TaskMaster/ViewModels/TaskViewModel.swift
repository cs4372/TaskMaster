//
//  TaskViewModel.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit

class TaskViewModel {    
    private var tasks: [Task] = []
    
    var numberOfTasks: Int {
        return tasks.count
    }
    
    func task(at index: Int) -> Task {
        return tasks[index]
    }
}
