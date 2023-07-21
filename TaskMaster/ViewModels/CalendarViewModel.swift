//
//  CalendarViewModel.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/18/23.
//

import Foundation
import FSCalendar

class CalendarViewModel {
    var selectedTasks: [Task]?
    var tasksByDate: [String: [Task]]?
    var selectedDate: String? = DateHelper.formattedFullDate(from: Date())
    var dateKeys: [String]?
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    func reloadData() {
        tasksByDate = dataManager.tasksByDate
        if let tasksByDate {
            selectedTasks = getTasks(date: selectedDate!)
            dateKeys = Array(tasksByDate.keys)
        }
    }
    
    func getTasks(date dateString: String) -> [Task]? {
           if let tasks = tasksByDate?[dateString] {
               return tasks
           }
            return nil
    }
    
    func getSelectedDateTasks(date: Date) {
        selectedDate = DateHelper.formattedFullDate(from: date)
        selectedTasks = getTasks(date: selectedDate!)
    }
    
    func getNumberOfEventsByDate(date: Date) -> Int {
        let dateString = DateHelper.formattedFullDate(from: date)
        
        if let dateKeys {
            if dateKeys.contains(dateString) {
                return 1
            }
        }
        return 0
    }
}
