//
//  TaskViewModel.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit

class TaskViewModel {
    weak var delegate: TaskViewVCDelegate?

    private var tasks: [Task] = []
    
    var numberOfTasks: Int {
        return tasks.count
    }
    
    func task(at index: Int) -> Task {
        return tasks[index]
    }
}
