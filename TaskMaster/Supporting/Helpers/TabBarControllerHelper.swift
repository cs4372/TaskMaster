//
//  TabBarControllerHelper.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/21/23.
//

import UIKit

func createTabBarController() -> UITabBarController {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        fatalError("AppDelegate not found")
    }
    
    let context = appDelegate.persistentContainer.viewContext
    
    let tabBarController = UITabBarController()
    
    // MARK: InitialLaunchViewController
    
    let initialLaunchViewModel = InitialLaunchViewModel()
    let InitialLaunchViewController = InitialLaunchViewController(initialLaunchViewModel: initialLaunchViewModel)

    // MARK: TaskViewController
    
    let taskViewModel = TaskViewModel(context: context)
    let TaskViewController = TaskViewController(taskViewModel: taskViewModel)
    TaskViewController.tabBarItem.title = "Tasks"
    TaskViewController.tabBarItem.image = UIImage(systemName: "list.bullet.clipboard")
    
    let dataManager = DataManager.shared

    // MARK: CalendarViewController

    let calendarViewModel = CalendarViewModel(dataManager: dataManager)
    let CalendarViewController = CalendarViewController(calendarViewModel: calendarViewModel)
    CalendarViewController.tabBarItem.title = "Calendar"
    CalendarViewController.tabBarItem.image = UIImage(systemName: "calendar")
    
    // MARK: CompletedViewController

    let completedTasksViewModel = CompletedTasksViewModel(context: context)
    let CompletedTasksViewController = CompletedTasksViewController(completedTasksViewModel: completedTasksViewModel)
    CompletedTasksViewController.tabBarItem.title = "Completed Tasks"
    CompletedTasksViewController.tabBarItem.image = UIImage(systemName: "checkmark.icloud")
            
    tabBarController.viewControllers = [TaskViewController, CalendarViewController, CompletedTasksViewController]

    return tabBarController
}
