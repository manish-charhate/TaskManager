//
//  MockTasksRepository.swift
//  TaskManagerTests
//
//  Created by Manish Charhate on 22/06/24.
//

import Foundation
@testable import TaskManager

final class MockTasksRepository: TasksRepository {
    
    var fetchTasksResult: Result<[TaskModel], Error>?
    var deleteTaskResult: Result<Void, Error>?
    var updateTaskResult: Result<Void, Error>?
    var createTaskResult: Result<Void, Error>?
    
    func createTask(_ task: TaskModel) async throws {
        if let result = createTaskResult {
            switch result {
            case .success:
                return
            case .failure(let error):
                throw error
            }
        }
    }

    func fetchTasks() async throws -> [TaskModel] {
        if let result = fetchTasksResult {
            switch result {
            case .success(let tasks):
                return tasks
            case .failure(let error):
                throw error
            }
        }
        return []
    }

    func deleteTask(_ task: TaskModel) async throws {
        if let result = deleteTaskResult {
            switch result {
            case .success:
                return
            case .failure(let error):
                throw error
            }
        }
    }

    func updateTask(_ task: TaskModel) async throws {
        if let result = updateTaskResult {
            switch result {
            case .success:
                return
            case .failure(let error):
                throw error
            }
        }
    }
}
