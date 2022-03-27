//
//  CoreDataManagerTests.swift
//  ToDoTests
//
//  Created by Nitesh on 26/03/22.
//

import XCTest
import Foundation
import UIKit
import CoreData

class CoreDataManagerTests: XCTestCase {
    
    func test_fetch_all_task() {
        CoreDataManager.shared.getAllTasks { result in
            switch result{
            case .success(let tasks):
                XCTAssertNotNil(tasks)
                if let task = tasks.first{
                    self.test_update_task(task: task)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    
    func test_delete_task() {
        CoreDataManager.shared.getAllTasks { result in
            switch result{
            case .success(let tasks):
                let totalTaskCount = tasks.count
                if !tasks.isEmpty{
                    CoreDataManager.shared.deleteTask(tasks.first!) { _ in
                        CoreDataManager.shared.getAllTasks { result in
                            switch result{
                            case .success(let currentTasks):
                                XCTAssertEqual(currentTasks.count, totalTaskCount-1)
                            case .failure(let error):
                                XCTFail(error.localizedDescription)
                            }
                        }
                    }
                }
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
        }
    }
    

    func test_update_task(task: Task) {
        CoreDataManager.shared.updateTaskIsCompleted(task, isComplted: true, completion: { result in
            switch result{
            case .success(let success):
                XCTAssertTrue(success)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
    }
}
