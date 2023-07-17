//
//  TaskCellViewModel.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit

struct TaskCellViewModel {
    let taskTitle: String
    let taskDueDate: String
    let taskColor: UIColor
    let checkboxImage: UIImage?
    
//    init() {
//        taskTitle = task.title ?? "No Tasks Added Yet"
//        taskDueDate = DateHelper.formattedDate(from: task.dueDate!)
//        
//        guard let color = UIColor(hexString: task.taskColor) else {
//            taskColor = .clear
//            checkboxImage = nil
//            return
//        }
//
//        taskColor = color
//        checkboxImage = UIImage(systemName: task.isCompleted ? "checkmark.circle" : "circle")?.withTintColor(ContrastColorOf(color, returnFlat: true))
//    }
}
