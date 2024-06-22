//
//  MockTaskDetailsRepository.swift
//  TaskManagerTests
//
//  Created by Manish Charhate on 22/06/24.
//

import Foundation
@testable import TaskManager

// Mock repository for testing
final class MockTaskDetailsRepository: TaskDetailsRepository {
    
    var shouldThrowError = false
    
    func updateTaskDetails(modifiedTask: TaskModel) async throws {
        if shouldThrowError {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test Error"])
        }
    }
    
    func deleteTask(_ taskId: String) async throws {
        if shouldThrowError {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Test Error"])
        }
    }
}
