//
//  TaskListViewModel.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import Combine
import Foundation

@MainActor
final class TaskListViewModel: ObservableObject {
    
    // MARK: Properties
    
    @Published var searchText = ""
    
    @Published var selectedStatus: TaskStatus = .all
    
    @Published private(set) var tasks: [TaskModel] = [
        TaskModel(title: "Task 1", description: "Description 1 Description 1 Description 1 Description 1 Deson 1 Description 1 Description 1 Description 1 Description 1 ", status: .todo, dueDate: Date()),
        TaskModel(title: "Task 2", description: "Description 2", status: .inProgress, dueDate: Date().addingTimeInterval(86400)),
        TaskModel(title: "Task 3", description: "Description 3", status: .done, dueDate: Date().addingTimeInterval(172800)),
        TaskModel(title: "Task 4", description: "Description 3", status: .done, dueDate: Date().addingTimeInterval(172800))
    ]
    
    var filteredTasks: [TaskModel] {
        tasks.filter { task in
            (selectedStatus == .all || task.status == selectedStatus) &&
            (searchText.isEmpty || task.title.lowercased().contains(searchText.lowercased()))
        }
    }
}
