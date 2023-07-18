//
//  TaskCellViewModel.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit

class TaskCellViewModel {
    let task: Task
    
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

        print("checkboxImageName", checkboxImageName)
        if let checkboxImage = UIImage(systemName: checkboxImageName) {
            let imageSize = CGSize(width: 80, height: 80)
            
            let renderer = UIGraphicsImageRenderer(size: imageSize)
            let resizedCheckboxImage = renderer.image { _ in
                checkboxImage.draw(in: CGRect(origin: .zero, size: imageSize))
            }
        }
        return UIImage(systemName: checkboxImageName)?.withTintColor(.white) ?? UIImage()
    }
    
    init(task: Task) {
        self.task = task
    }
}
