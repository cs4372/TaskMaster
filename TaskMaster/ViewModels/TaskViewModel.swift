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
    var tasksByDate: [String: [Task]] {
        return groupTasksByDate()
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    lazy var dateFormatter: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         return formatter
     }()
    
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
    
    func groupTasksByDate() -> [String: [Task]] {
        var tasksByDate: [String: [Task]] = [:]

        for task in tasks {
            guard let dueDate = task.dueDate else { continue }
            
            let dateString = DateHelper.formattedFullDate(from: dueDate)
            
            if tasksByDate[dateString] == nil {
                tasksByDate[dateString] = [task]
            } else {
                tasksByDate[dateString]?.append(task)
            }
        }
        return tasksByDate
    }
    
    func numberOfTasksByDate(forSection section: Int) -> Int {
         let sortedTasksByDate = tasksByDate.keys.sorted(by: { dateFormatter.date(from: $0)! < dateFormatter.date(from: $1)! })
         let date = sortedTasksByDate[section]
         
         if let tasks = tasksByDate[date] {
             return tasks.count
         }
         
         return 0
     }
    
    func getHeaderInSection(forSection section: Int) -> String? {
        let sectionDates = Array(tasksByDate.keys).sorted()
        let sectionDateString = sectionDates[section]
        if let sectionDate = dateFormatter.date(from: sectionDateString) {
            return dateFormatter.string(from: sectionDate)
        } else {
            return nil
        }
    }
    
    func saveTasks() {
        do {
            print("save tasks ====>")
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
    
    func saveTasks(currentTask: Task) {
        print("task in Taskvm", task)
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
