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
    @Published private(set) var errorMessage = ""
    @Published private(set) var showError = false
    @Published private(set) var isLoading = false
    
    @Published var selectedStatus: TaskStatus = .all
    
    @Published private(set) var tasks: [TaskModel] = []
    
    var filteredTasks: [TaskModel] {
        tasks.filter { task in
            (selectedStatus == .all || task.statusType == selectedStatus) &&
            (searchText.isEmpty || (task.title ?? "").lowercased().contains(searchText.lowercased()))
        }
    }
    
    private let repository: TasksRepository
    
    // MARK: Init
    
    init(repository: TasksRepository = TasksFirebaseRepository()) {
        self.repository = repository
    }
    
    // MARK: Public methods
    
    func fetchAllTasks() async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            tasks = try await repository.fetchTasks()
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func createTask() async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        let task = TaskModel(id: UUID().uuidString, title: "Task 2", description: "Description 2", status: "done", dueDate: Date())
        
        do {
            try await repository.createTask(task)
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteTask(_ task: TaskModel) async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            try await repository.deleteTask(task)
            tasks.removeAll { $0.id == task.id }
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func updateStatus(to status: TaskStatus, for task: TaskModel) async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let modifiedTask = TaskModel(
                id: task.id,
                title: task.title,
                description: task.description,
                status: status.rawValue,
                dueDate: task.dueDate
            )
            try await repository.updateTask(modifiedTask)
            
            // Refresh data
            await fetchAllTasks()
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
}
