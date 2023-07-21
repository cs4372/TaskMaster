//
//  AddTaskViewModel.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit
import CoreData
import ChameleonFramework

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
        if let task = editTask {
            task.title = title
            task.dueDate = dueDate
            delegate?.didEditTask(task)
        } else {
            let newTask = Task(context: context)
            newTask.title = title
            newTask.dueDate = dueDate
            let color = RandomFlatColorWithShade(.light)
            let lightenedColor = color.lighten(byPercentage: 0.3)
            newTask.taskColor = (lightenedColor?.hexValue())!
            newTask.isCompleted = false
            
            do {
                try context.save()
                delegate?.didAddTask(newTask)
            } catch {
                print("Error saving task: \(error)")
            }
        }
    }
}

