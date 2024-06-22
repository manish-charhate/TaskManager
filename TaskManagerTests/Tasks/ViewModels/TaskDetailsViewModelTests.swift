//
//  TaskDetailsViewModelTests.swift
//  TaskManagerTests
//
//  Created by Manish Charhate on 22/06/24.
//

import XCTest
@testable import TaskManager

@MainActor
final class TaskDetailsViewModelTests: XCTestCase {

    private var repository: MockTaskDetailsRepository!
    private var viewModel: TaskDetailsViewModel!
    private var task: TaskModel!

    override func setUp() {
        super.setUp()
        repository = MockTaskDetailsRepository()
        
        task = TaskModel(
            id: "1",
            title: "Test Task",
            description: "Test Description",
            status: TaskStatus.todo.rawValue,
            dueDate: Date(),
            creationDate: Date()
        )
        viewModel = TaskDetailsViewModel(task: task, repository: repository)
    }

    // Initialization Tests
    func testInitialization() {
        XCTAssertEqual(viewModel.title, "Test Task")
        XCTAssertEqual(viewModel.description, "Test Description")
        XCTAssertEqual(viewModel.dueDate, task.dueDate)
        XCTAssertEqual(viewModel.taskStatus, .todo)
        XCTAssertFalse(viewModel.isEditing)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "")
        XCTAssertEqual(viewModel.editButtonTitle, "Edit")
    }

    // Toggle Editing Mode Tests
    func testToggleEditingMode_InitiallyFalse() {
        viewModel.toggleEditingMode()
        XCTAssertTrue(viewModel.isEditing)
        XCTAssertEqual(viewModel.editButtonTitle, "Done")
    }

    func testToggleEditingMode_InitiallyTrue() async throws {
        // Sets isEditing to true
        viewModel.toggleEditingMode()
        
        // Toggle again to set editing mode to false
        viewModel.toggleEditingMode()
        
        try await waitForAsyncTasks()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isEditing)
        XCTAssertEqual(viewModel.editButtonTitle, "Edit")
    }

    // Update Task Details Tests
    func testUpdateTaskDetails_Success() async throws {
        // Enable editing mode
        viewModel.toggleEditingMode()
        
        // Update task details
        viewModel.title = "Updated Title"
        viewModel.description = "Updated Description"
        
        await viewModel.updateTaskDetails()
        
        try await waitForAsyncTasks()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isEditing)
        XCTAssertEqual(viewModel.editButtonTitle, "Edit")
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "")
    }

    func testUpdateTaskDetails_Failure() async throws {
        repository.shouldThrowError = true
        
        // Enable editing mode
        viewModel.toggleEditingMode()
        
        await viewModel.updateTaskDetails()
        
        try await waitForAsyncTasks()

        // Editing mode should remain On in case of failure
        XCTAssertTrue(viewModel.isEditing)
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Test Error")
    }

    // Update Task Status Tests
    func testUpdateTaskStatus_Success() async throws {
        await viewModel.updateTaskStatus(.done)
        
        try await waitForAsyncTasks()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.taskStatus, .done)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "")
    }

    func testUpdateTaskStatus_Failure() async throws {
        repository.shouldThrowError = true
        
        await viewModel.updateTaskStatus(.done)
        
        try await waitForAsyncTasks()
        
        XCTAssertEqual(viewModel.taskStatus, .todo)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Test Error")
    }

    // Delete Task Tests
    func testDeleteTask_Success() async throws {
        let result = await viewModel.deleteTask()
        
        try await waitForAsyncTasks()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(result)
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "")
    }

    func testDeleteTask_Failure() async throws {
        repository.shouldThrowError = true
        
        let result = await viewModel.deleteTask()
        
        try await waitForAsyncTasks()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(result)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Test Error")
    }

    // Change Editing Mode Tests
    func testChangeEditingMode() {
        viewModel.changeEditingMode()
        XCTAssertTrue(viewModel.isEditing)
        XCTAssertEqual(viewModel.editButtonTitle, "Done")
        
        viewModel.changeEditingMode()
        XCTAssertFalse(viewModel.isEditing)
        XCTAssertEqual(viewModel.editButtonTitle, "Edit")
    }
    
    // Helper method to wait for async tasks
    private func waitForAsyncTasks() async throws {
        try await Task.sleep(nanoseconds: 100_000_000)
    }
}
