//
//  TaskViewModel.swift
//  ToDo
//
//  Created by Nitesh on 27/03/22.
//

import Foundation

struct TaskViewModel {
    private(set) var canSubmit: Box<Bool> = Box(false)
    
    var taskTitle: String = ""{
        didSet{
            canSubmit.value = taskTitle.isWhitespace == false
        }
    }
    var taskDescription: String = ""
    var selectedDate: Date = Date()
    
    func addTask(completion: @escaping (Result<Task,Error>)-> Void){
        CoreDataManager.shared.addTask(title: taskTitle, taskDescription: taskDescription, isCompleted: false, date: selectedDate, completion: completion)
    }
    
}
