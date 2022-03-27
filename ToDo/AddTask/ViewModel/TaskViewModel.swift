//
//  TaskViewModel.swift
//  ToDo
//
//  Created by Nitesh on 27/03/22.
//

import Foundation

final class TaskViewModel {
    
    private(set) var canSubmit: Box<Bool> = Box(false)
    
    var taskTitle: String = ""{
        didSet{
            canSubmit.value = taskTitle.isWhitespace == false
        }
    }
    var taskDescription: String = ""
    var selectedDate: Date = Date()
    var selectedTask: Task?
    
    func addTask(completion: @escaping (Result<Task,Error>)-> Void){
        CoreDataManager.shared.addTask(title: taskTitle, taskDescription: taskDescription, isCompleted: false, date: selectedDate, completion: completion)
    }
    
    func updateTask(completion: @escaping (Result<Task,Error>)-> Void){
        guard let selectedTask = self.selectedTask else { return }
        CoreDataManager.shared.updateTaskIsCompleted(selectedTask, title: taskTitle, taskDescription: taskDescription, isCompleted: false, date: selectedDate, completion: completion)
    }
    
    func setSelectedTask(task: Task){
        self.selectedTask = task
        self.taskTitle = task.title ?? ""
        self.taskDescription = task.taskDescription ?? ""
        self.selectedDate = task.date ?? Date()
    }
    
    
    
}
