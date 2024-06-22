//
//  TasksRepository.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import Foundation

protocol TasksRepository {
    
    func createTask(_ task: TaskModel) async throws
    
    func fetchTasks() async throws -> [TaskModel]
    
    func updateTask(_ task: TaskModel) async throws
    
    func deleteTask(_ task: TaskModel) async throws
}
