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
    
}
