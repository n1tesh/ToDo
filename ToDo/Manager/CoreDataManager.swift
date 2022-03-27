//
//  CoreDataManager.swift
//  ToDo
//
//  Created by Nitesh on 26/03/22.
//

import Foundation
import CoreData

final class CoreDataManager {

    static let shared = CoreDataManager()
    
    private init() {}
    
    enum DatabaseError : Error{
        case failedToSaveWithOutAnyChanges
        case failedToSave
        case failedFetchData
        case failedToDeleteData
        case failedToUpdate
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "ToDo")
        persistentContainer.loadPersistentStores { (_, err) in
            guard let err = err else {
                return
            }
            print(err.localizedDescription)
        }
        return persistentContainer
    }()

    fileprivate var moc: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }

    private func getAll<T: NSManagedObject>(completion: @escaping (Result<[T],Error>)-> Void){
        do {
            let fetchRequest = NSFetchRequest<T>(entityName: "\(T.self)")
            let data =  try self.moc.fetch(fetchRequest)
            completion(.success(data))
        } catch {
            print(error)
            completion(.failure(DatabaseError.failedFetchData))
        }
    }

    private func save(completion: @escaping (Result<Bool,Error>)-> Void) {
        guard self.moc.hasChanges else {
            completion(.failure(DatabaseError.failedToSaveWithOutAnyChanges))
            return
        }
        do {
            try self.moc.save()
            completion(.success(true))
        } catch {
            print(error)
            completion(.failure(DatabaseError.failedToSave))
        }
    }

}

extension CoreDataManager{
    
    func getAllTasks(completion: @escaping (Result<[Task],Error>)-> Void) {
        CoreDataManager.shared.getAll(completion: completion)
    }
    
    func addTask(title: String, taskDescription: String?, isCompleted: Bool, date: Date?, completion: @escaping (Result<Task,Error>)-> Void) {
        let task = Task(context: moc)
        task.title = title
        task.taskDescription = taskDescription
        task.isCompleted = isCompleted
        task.date = date
        save { result in
            switch result{
            case .success(_):
                completion(.success(task))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func deleteTask(_ task: Task, completion: @escaping (Result<Bool,Error>)-> Void) {
        moc.delete(task)
        do {
            try moc.save()
            completion(.success(true))
        } catch {
            moc.rollback()
            print("Deletion failed \(error)")
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
    func updateTaskIsCompleted(_ task: Task, title: String, taskDescription: String?, isCompleted: Bool, date: Date?, completion: @escaping (Result<Task,Error>)-> Void) {
        task.title = title
        task.taskDescription = taskDescription
        task.isCompleted = isCompleted
        task.date = date
        do {
            try moc.save()
            completion(.success(task))
        } catch {
            moc.rollback()
            print("update failed \(error)")
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
}
