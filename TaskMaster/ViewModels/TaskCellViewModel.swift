//
//  TaskCellViewModel.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
    func didToggleCheckbox(for cell: TaskCollectionViewCell)
}

class TaskCellViewModel {
    let task: Task
    
//    weak var delegate: TaskCellViewModelDelegate?
    weak var taskViewModel: TaskViewModel?

    var taskTitle: String {
        return task.title ?? "No Tasks Added Yet"
    }
    
    var taskDueDate: String {
        return DateHelper.formattedDate(from: task.dueDate!)
    }
    
    var taskColor: UIColor {
//        guard let color = UIColor(hexString: task.taskColor) else {
//            return .white
//        }
//        return color
        return .orange
    }
    
    var checkboxImage: UIImage? {
        let checkboxImageName = task.isCompleted ? "checkmark.circle" : "circle"

        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .large)
        let image = UIImage(systemName: checkboxImageName, withConfiguration: imageConfiguration)
        return image
    }
    
    init(task: Task) {
        self.task = task
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
        let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { [weak self] _ in
            guard let self = self else { return }
//
//            if self.tasks?[indexPath.row] != nil {
//                let addTaskCV = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
//                let task = self.tasks?[indexPath.row]
//                addTaskCV.delegate = self
//
//                if let currentTask = task {
//                    addTaskCV.editTask = currentTask
//                }
//
//                self.presentPanModal(addTaskCV)
//            }
        }
//
        return editAction
    }
    
    private func createDeleteAction(for indexPath: IndexPath) -> UIAction {
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
//            if let deleteItem = self.tasks?[indexPath.row] {
//                guard let dueDate = deleteItem.dueDate else { return }
//                
//                let dateString = DateHelper.formattedFullDate(from: dueDate)
                
                //                if var tasksOnDueDate = tasksByDate[dateString] {
                //                    if let taskIndex = tasksOnDueDate.firstIndex(of: deleteItem) {
                //                        tasksOnDueDate.remove(at: taskIndex)
                //                        tasksByDate[dateString] = tasksOnDueDate
                //
                //                        if tasksOnDueDate.isEmpty {
                //                            tasksByDate.removeValue(forKey: dateString)
                //                        }
                //                    }
                //                }
                //
                //                self.context.delete(deleteItem)
                //                self.tasks?.remove(at: indexPath.row)
                //                self.saveTasks()
                //                if let tasks = tasks {
                //                    DataManager.shared.groupTasksByDate(tasks: tasks)
                //                }
                //                self.collectionView.reloadData()
                //                self.tableView.reloadData()
                //            }
            }
            
            return deleteAction
        }
    }

