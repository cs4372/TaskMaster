//
//  TaskViewModel.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit
import CoreData
import PanModal

protocol TaskViewModelDelegate: AnyObject {
    func presentAddTaskVC(with viewModel: AddTaskViewModel)
    func reloadData()
}

class TaskViewModel {
    
    weak var delegate: TaskViewModelDelegate?
    private let context: NSManagedObjectContext
    var tasks: [Task] = []
    
    var tasksByDate: [String: [Task]] = [:]
    
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
        let isCompletedPredicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: false))
        fetchRequest.sortDescriptors = [sortByDueDate]
        fetchRequest.predicate = isCompletedPredicate
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func groupTasksByDate() {
        var groupedTasksByDate: [String: [Task]] = [:]

        for task in tasks {
            guard let dueDate = task.dueDate else { continue }
            
            let dateString = DateHelper.formattedFullDate(from: dueDate)
            
            if groupedTasksByDate[dateString] == nil {
                groupedTasksByDate[dateString] = [task]
            } else {
                groupedTasksByDate[dateString]?.append(task)
            }
        }
        
        tasksByDate = groupedTasksByDate
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
    }
    
    func saveTasks(currentTask: Task) {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func createContextMenuConfiguration(for indexPath: IndexPath) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = self.createEditAction(for: indexPath)
            let deleteAction = self.createDeleteAction(for: indexPath)
            
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
        
        return configuration
    }
    
    private func createEditAction(for indexPath: IndexPath) -> UIAction {
        let task = task(at: indexPath.row)

        let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { [weak self] _ in
            guard let self = self else { return }
                        
            let addTaskViewModel = AddTaskViewModel(context: self.context)
            addTaskViewModel.editTask = task
            
            self.delegate?.presentAddTaskVC(with: addTaskViewModel)
        }

        return editAction
    }
    
    private func createDeleteAction(for indexPath: IndexPath) -> UIAction {
        let task = task(at: indexPath.row)
        
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            guard let dueDate = task.dueDate else { return }
            let dateString = DateHelper.formattedFullDate(from: dueDate)
            
            if var tasksOnDueDate = tasksByDate[dateString] {
                if let taskIndex = tasksOnDueDate.firstIndex(of: task) {
                    tasksOnDueDate.remove(at: taskIndex)
                    tasksByDate[dateString] = tasksOnDueDate
                    
                    if tasksOnDueDate.isEmpty {
                        tasksByDate.removeValue(forKey: dateString)
                    }
                }
            }
            
            context.delete(task)
            tasks.remove(at: indexPath.row)
            saveTasks()
            DataManager.shared.groupTasksByDate(tasks: tasks)
            self.delegate?.reloadData()
        }
        return deleteAction
    }
    
    func swipeActionsConfiguration(for indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = task(at: indexPath.row)

        let editAction = UIContextualAction(style: .normal, title: "Edit") {[weak self] (_, _, completionHandler) in
            guard let self = self else { return }
                        
            let addTaskViewModel = AddTaskViewModel(context: self.context)
            addTaskViewModel.editTask = task
            
            self.delegate?.presentAddTaskVC(with: addTaskViewModel)
            self.delegate?.reloadData()
            completionHandler(true)
        }
//        editAction.backgroundColor = .flatSkyBlue()
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            let sectionDates = Array(self.tasksByDate.keys).sorted()
            let sectionDateString = sectionDates[indexPath.section]
            
            var tasksForSection = self.tasksByDate[sectionDateString]
            
            if let deleteItem = tasksForSection?[indexPath.row] {
                tasksForSection?.remove(at: indexPath.row)
                self.tasksByDate[sectionDateString] = tasksForSection
                
                if var tasksOnDueDate = tasksByDate[sectionDateString] {
                    if let taskIndex = tasksOnDueDate.firstIndex(of: deleteItem) {
                        tasksOnDueDate.remove(at: taskIndex)
                        tasksByDate[sectionDateString] = tasksOnDueDate
                    }
                }
                
                if tasksForSection?.isEmpty ?? false {
                    self.tasksByDate.removeValue(forKey: sectionDateString)
                }
                
                self.context.delete(deleteItem)
                self.saveTasks()
                loadTasks()
                DataManager.shared.groupTasksByDate(tasks: tasks)

                delegate?.reloadData()
                completionHandler(true)
            }
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
    
    func toggleCheckbox(for indexPath: IndexPath) {
          let task = tasks[indexPath.row]
          task.isCompleted.toggle()
          saveTasks()
      }
    
    func setupUserNameLabel() -> String {
        let greeting = "Hi User!"

        if let savedUserName = UserDefaults.standard.string(forKey: "UserName") {
            let greeting = "Hi \(savedUserName)!"
            return greeting
        }
        return greeting
    }
}
