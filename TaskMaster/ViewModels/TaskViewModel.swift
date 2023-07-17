//
//  TaskViewModel.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit
import CoreData

class TaskViewModel {
    private let context: NSManagedObjectContext
    private var tasks: [Task] = []
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func loadTasks() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortByDueDate = NSSortDescriptor(key: "dueDate", ascending: true)
//        let isCompletedPredicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: false))
        fetchRequest.sortDescriptors = [sortByDueDate]
//        fetchRequest.predicate = isCompletedPredicate
        
        do {
            tasks = try context.fetch(fetchRequest)
            print("count", tasks.count)
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    var numberOfTasks: Int {
        return tasks.count
    }
    
    func task(at index: Int) -> Task {
        return tasks[index]
    }
    
    func addTask(newTask: Task) {
        tasks.append(newTask)
        saveTasks()
        print("numberOfTasks inside addTask", numberOfTasks)
    }
}
