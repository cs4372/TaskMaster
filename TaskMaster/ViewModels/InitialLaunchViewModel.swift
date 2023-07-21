//
//  InitialLaunchViewModel.swift
//  TaskMaster
//
//  Created by Catherine Shing on 7/21/23.
//

import Foundation

class InitialLaunchViewModel {
    var userName: String = ""
    
    func saveUserName(_ name: String) {
        userName = name
        UserDefaults.standard.set(name, forKey: "UserName")
    }
}
