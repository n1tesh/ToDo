//
//  HomeViewModelTests.swift
//  ToDoTests
//
//  Created by Nitesh on 27/03/22.
//

import XCTest

class HomeViewModelTests: XCTestCase {

    func testViewModel() {
        let viewModel = HomeViewModel()
        self.test_tasksCount_equals_dbCount(viewModel: viewModel)
    }
    
    func test_tasksCount_equals_dbCount(viewModel: HomeViewModel){
        CoreDataManager.shared.getAllTasks { result in
            switch result{
            case .success(let tasks):
                XCTAssertEqual(viewModel.tasks.value.count, tasks.count)
            case .failure(_):
                break
            }
        }
    }

}
