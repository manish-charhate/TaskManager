//
//  CreateTaskViewModelTests.swift
//  TaskManagerTests
//
//  Created by Manish Charhate on 22/06/24.
//

import XCTest
@testable import TaskManager

@MainActor
final class CreateTaskViewModelTests: XCTestCase {

    var viewModel: CreateTaskViewModel!
    var mockRepository: MockTasksRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockTasksRepository()
        viewModel = CreateTaskViewModel(repository: mockRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.taskTitle, "")
        XCTAssertEqual(viewModel.taskDescription, "")
        XCTAssertEqual(viewModel.currentStatus, .todo)
        XCTAssertEqual(viewModel.isLoading, false)
        XCTAssertEqual(viewModel.showError, false)
        XCTAssertEqual(viewModel.errorMessage, "")
        XCTAssert(Calendar.current.isDate(viewModel.dueDate, inSameDayAs: Date()))
    }

    func testCreateTaskWithEmptyTitle() async {
        viewModel.taskTitle = ""
        let success = await viewModel.createTask()
        
        XCTAssertFalse(success)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Please add title for the task")
    }

    func testSuccessfulTaskCreation() async {
        viewModel.taskTitle = "New Task"
        viewModel.taskDescription = "Description of the new task"
        viewModel.currentStatus = .inProgress
        viewModel.dueDate = Date().addingTimeInterval(60*60*24) // 1 day later
        
        mockRepository.createTaskResult = .success(())
        
        let success = await viewModel.createTask()
        
        XCTAssertTrue(success)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "")
        XCTAssertFalse(viewModel.isLoading)
    }

    func testTaskCreationFailure() async {
        viewModel.taskTitle = "New Task"
        viewModel.taskDescription = "Description of the new task"
        viewModel.currentStatus = .inProgress
        viewModel.dueDate = Date().addingTimeInterval(60*60*24) // 1 day later
        
        mockRepository.createTaskResult = .failure(
            NSError(
                domain: "",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Network error"]
            )
        )
        
        let success = await viewModel.createTask()
        
        XCTAssertFalse(success)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Network error")
        XCTAssertFalse(viewModel.isLoading)
    }
}
