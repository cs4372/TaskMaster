//
//  CompletedTasksViewModel.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/19/23.
//

import Foundation
import CoreData
import UIKit

protocol CompletedTasksViewModelDelegate: AnyObject {
    func reloadData()
    func completedTasksDidUpdate(count: Int)
}

class CompletedTasksViewModel {
    private let context: NSManagedObjectContext
    
    weak var delegate: CompletedTasksViewModelDelegate?
    
    var completedTasks: [Task] = []
    
    func completedTasksChange() {
        loadTasks()
        let count = completedTasks.count
        print("count ==>", count)
        delegate?.completedTasksDidUpdate(count: count)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let isCompletedPredicate = NSPredicate(format: "isCompleted == %d", true)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [isCompletedPredicate, additionalPredicate])
        } else {
            request.predicate = isCompletedPredicate
        }
        
        do {
            completedTasks = try context.fetch(request)
            print("completedTasks ==>", completedTasks)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func toggleTaskCompletion(at index: Int) {
            guard index >= 0 && index < completedTasks.count else { return }
            completedTasks[index].isCompleted.toggle()
            saveTasks()
    }
    
    func task(at index: Int) -> Task? {
        return completedTasks[index]
    }
    
    func createContextMenuConfiguration(for indexPath: IndexPath) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let setIncompleteAction = self.createSetIncompleteAction(for: indexPath)
            let deleteAction = self.createDeleteAction(for: indexPath)
            
            return UIMenu(title: "", children: [setIncompleteAction, deleteAction])
        }
        
        return configuration
    }
    
    private func createSetIncompleteAction(for indexPath: IndexPath) -> UIAction {
        let editAction = UIAction(title: "Set it to incomplete", image: UIImage(systemName: "pencil")) { [weak self] _ in
            guard let self = self else { return }
            
                let task = completedTasks[indexPath.row]
                task.isCompleted = false
                completedTasks.remove(at: indexPath.row)
                self.saveTasks()
                delegate?.reloadData()
        }
        
        return editAction
    }
    
    private func createDeleteAction(for indexPath: IndexPath) -> UIAction {
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
                let deleteItem = completedTasks[indexPath.row]
                self.context.delete(deleteItem)
                completedTasks.remove(at: indexPath.row)
                self.saveTasks()
                //                self.collectionView.reloadData()
                delegate?.reloadData()
                completedTasksChange()
        }
        
        return deleteAction
    }
    
    func toggleCheckbox(for indexPath: IndexPath) {
            let task = completedTasks[indexPath.row]
            task.isCompleted.toggle()
            saveTasks()
        delegate?.reloadData()
    }
}
