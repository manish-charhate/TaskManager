//
//  TaskDetailsRepository.swift
//  TaskManager
//
//  Created by Manish Charhate on 22/06/24.
//

import Foundation

protocol TaskDetailsRepository {
    
    func updateTaskDetails(modifiedTask: TaskModel) async throws
    
    func deleteTask(_ taskId: String) async throws
}
