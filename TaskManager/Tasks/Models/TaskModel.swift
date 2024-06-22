//
//  TaskModel.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import Foundation

struct TaskModel: Identifiable, Codable, Hashable {
    let id: String
    let title: String?
    let description: String?
    let status: String?
    let dueDate: Date?
    let creationDate: Date?
    
    var statusType: TaskStatus {
        guard let status else { return .all }
        return TaskStatus(rawValue: status) ?? .all
    }
}

enum TaskStatus: String, CaseIterable {
    case all
    case todo
    case inProgress = "in progress"
    case done
}

enum SortingCriteria: String, CaseIterable {
    case creationDate = "creation date"
    case title
    case dueDate = "due date"
}
