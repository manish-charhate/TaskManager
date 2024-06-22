//
//  TaskListViewModelTests.swift
//  TaskManagerTests
//
//  Created by Manish Charhate on 22/06/24.
//

import XCTest
@testable import TaskManager

@MainActor
final class TaskListViewModelTests: XCTestCase {
    
    var viewModel: TaskListViewModel!
    var mockRepository: MockTasksRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockTasksRepository()
        viewModel = TaskListViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertEqual(viewModel.errorMessage, "")
        XCTAssertEqual(viewModel.showError, false)
        XCTAssertEqual(viewModel.isLoading, false)
        XCTAssertEqual(viewModel.selectedStatus, .all)
        XCTAssertTrue(viewModel.tasks.isEmpty)
    }

    func testFetchAllTasksSuccess() async {
        // Given
        let expectedTasks = [TaskModel(id: "1", title: "Task 1", description: "Desc 1", status: "todo", dueDate: Date())]
        mockRepository.fetchTasksResult = .success(expectedTasks)
        
        // When
        await viewModel.fetchAllTasks()
        
        // Then
        XCTAssertEqual(viewModel.isLoading, false)
        XCTAssertEqual(viewModel.tasks, expectedTasks)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "")
    }
    
    func testFetchAllTasksFailure() async {
        // Given
        mockRepository.fetchTasksResult = .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fetch Error"]))
        
        // When
        await viewModel.fetchAllTasks()
        
        // Then
        XCTAssertEqual(viewModel.isLoading, false)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Fetch Error")
        XCTAssertTrue(viewModel.tasks.isEmpty)
    }
    
    func testDeleteTaskSuccess() async {
        // Given
        let task = TaskModel(id: "1", title: "Task 1", description: "Desc 1", status: "todo", dueDate: Date())
        mockRepository.fetchTasksResult = .success([task])
        await viewModel.fetchAllTasks()
        
        mockRepository.deleteTaskResult = .success(())
        
        // When
        await viewModel.deleteTask(task)
        
        // Then
        XCTAssertEqual(viewModel.isLoading, false)
        XCTAssertTrue(viewModel.tasks.isEmpty)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "")
    }
    
    func testDeleteTaskFailure() async {
        // Given
        let task = TaskModel(id: "1", title: "Task 1", description: "Desc 1", status: "todo", dueDate: Date())
        mockRepository.fetchTasksResult = .success([task])
        await viewModel.fetchAllTasks()
        mockRepository.deleteTaskResult = .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Delete Error"]))
        
        // When
        await viewModel.deleteTask(task)
        
        // Then
        XCTAssertEqual(viewModel.isLoading, false)
        XCTAssertEqual(viewModel.tasks, [task])
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Delete Error")
    }
    
    func testUpdateStatusSuccess() async {
        // Given
        let task = TaskModel(id: "1", title: "Task 1", description: "Desc 1", status: "todo", dueDate: Date())
        mockRepository.fetchTasksResult = .success([task])
        await viewModel.fetchAllTasks()
        
        let updatedTask = TaskModel(id: "1", title: "Task 1", description: "Desc 1", status: "done", dueDate: Date())
        mockRepository.updateTaskResult = .success(())
        mockRepository.fetchTasksResult = .success([updatedTask])
        
        // When
        await viewModel.updateStatus(to: .done, for: task)
        
        // Then
        XCTAssertEqual(viewModel.isLoading, false)
        XCTAssertEqual(viewModel.tasks, [updatedTask])
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "")
    }
    
    func testUpdateStatusFailure() async {
        // Given
        let task = TaskModel(id: "1", title: "Task 1", description: "Desc 1", status: "todo", dueDate: Date())
        mockRepository.fetchTasksResult = .success([task])
        await viewModel.fetchAllTasks()
        mockRepository.updateTaskResult = .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Update Error"]))
        
        // When
        await viewModel.updateStatus(to: .done, for: task)
        
        // Then
        XCTAssertEqual(viewModel.isLoading, false)
        XCTAssertEqual(viewModel.tasks, [task])
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Update Error")
    }
    
    func testFilteredTasks() async {
        // Given
        let task1 = TaskModel(id: "1", title: "Task 1", description: "Desc 1", status: "todo", dueDate: Date())
        let task2 = TaskModel(id: "2", title: "Task 2", description: "Desc 2", status: "done", dueDate: Date())
        mockRepository.fetchTasksResult = .success([task1, task2])
        await viewModel.fetchAllTasks()
        
        // When
        viewModel.selectedStatus = .done
        
        // Then
        XCTAssertEqual(viewModel.filteredTasks, [task2])
        
        // When
        viewModel.selectedStatus = .all
        viewModel.searchText = "Task 1"
        
        // Then
        XCTAssertEqual(viewModel.filteredTasks, [task1])
        
        // When
        viewModel.selectedStatus = .todo
        viewModel.searchText = "Task 1"
        
        // Then
        XCTAssertEqual(viewModel.filteredTasks, [task1])
        
        // When
        viewModel.selectedStatus = .all
        viewModel.searchText = ""
        
        // Then
        XCTAssertEqual(viewModel.filteredTasks, [task1, task2])
    }
}
