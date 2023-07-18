//
//  AddTaskViewModel.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit
import CoreData

protocol AddTaskViewDelegate: AnyObject {
    func didAddTask(_ task: Task)
    func didEditTask(_ task: Task)
}

class AddTaskViewModel {
    
    var editTask: Task?
    weak var delegate: AddTaskViewDelegate?
    
    private let context: NSManagedObjectContext
     
     init(context: NSManagedObjectContext) {
         self.context = context
     }
    
    func saveTask(title: String, dueDate: Date) {
        let newTask = Task(context: context)
        newTask.title = title
        newTask.dueDate = dueDate
        newTask.isCompleted = false

        print("new Task", newTask)
        
        do {
            try context.save()
            delegate?.didAddTask(newTask)
        } catch {
            print("Error saving task: \(error)")
        }
    }
}

