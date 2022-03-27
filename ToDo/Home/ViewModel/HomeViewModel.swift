//
//  HomeViewModel.swift
//  ToDo
//
//  Created by Nitesh on 26/03/22.
//

import Foundation


final class HomeViewModel{
    
    enum TaskListTypes: Int, CaseIterable {
        case today = 0, tomorrow = 1, upcoming = 2
        var description: String {
            switch self {
            case .today:
                return "Today"
            case .tomorrow:
                return "Tomorrow"
            case .upcoming:
                return "Upcoming"
            }
        }
    }
    
    private(set) var errorMessage: Box<String?> = Box(nil)
    private(set) var tasks: Box<[Task]> = Box([Task]())
    private var allTasks: [Task] = []
    var selectedSegmentIndex = 0{
        didSet{
            self.updateSelectedSegmentIndex(index: selectedSegmentIndex)
        }
    }
    
    init() {
        CoreDataManager.shared.getAllTasks { result in
            switch result{
            case .success(let tasks):
                self.allTasks = tasks
            case .failure(let error):
                self.errorMessage.value =  error.localizedDescription
            }
        }
    }
    
    func didAddTask(task: Task){
        allTasks.append(task)
        self.updateSelectedSegmentIndex(index: selectedSegmentIndex)
    }
     
    func getAllSegments() -> [TaskListTypes]{
        TaskListTypes.allCases
    }
    
    private func updateSelectedSegmentIndex(index: Int){
        let taskListType = TaskListTypes.allCases[index]
        switch taskListType{
        case .today:
            self.tasks.value = allTasks.filter{$0.date?.isInToday ?? false}
        case .tomorrow:
            self.tasks.value = allTasks.filter{$0.date?.isInTomorrow ?? false}.sorted { $0.date ?? Date() < $1.date ?? Date() }
        case .upcoming:            
            self.tasks.value = allTasks.filter{($0.date ?? Date()) > Date().tomorrow}.sorted { $0.date ?? Date() < $1.date ?? Date() }
        }
    }
    
    func deleteTask(task: Task){
        CoreDataManager.shared.deleteTask(task) { result in
            switch result{
            case .success(let success):
                guard success else { return }
                self.allTasks.removeAll(where: {$0.objectID == task.objectID})
                self.updateSelectedSegmentIndex(index: self.selectedSegmentIndex)
            case .failure(let error):
                self.errorMessage.value =  error.localizedDescription
            }
        }
    }
    
}
