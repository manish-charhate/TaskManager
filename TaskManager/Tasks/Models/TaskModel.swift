//
//  TaskModel.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import Foundation

struct TaskModel: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let status: TaskStatus
    let dueDate: Date
}

enum TaskStatus: String, CaseIterable {
    case all
    case todo
    case inProgress = "in progress"
    case done
}
