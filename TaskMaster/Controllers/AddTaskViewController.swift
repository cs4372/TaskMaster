//
//  AddTaskViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/16/23.
//

import UIKit

protocol TaskViewVCDelegate: AnyObject {
    func didAddTask(_ task: Task)
    func didEditTask(_ task: Task)
}

class AddTaskViewController: UIViewController {
}
