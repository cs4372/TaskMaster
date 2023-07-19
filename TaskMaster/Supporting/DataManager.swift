//
//  DataManager.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/18/23.
//

import UIKit

protocol DataManagerProtocol {
    var tasksByDate: [String: [Task]]? { get }
    func groupTasksByDate(tasks: [Task])
}

class DataManager: DataManagerProtocol {
    static let shared = DataManager()
    
    var tasksByDate: [String: [Task]]?
        
    func groupTasksByDate(tasks: [Task]) {
        tasksByDate = [:]
        
        for task in tasks {
            guard let dueDate = task.dueDate else { continue }
            
            let dateString = DateHelper.formattedFullDate(from: dueDate)
            
            if tasksByDate?[dateString] == nil {
                tasksByDate?[dateString] = [task]
            } else {
                tasksByDate?[dateString]?.append(task)
            }
        }
    }
}
