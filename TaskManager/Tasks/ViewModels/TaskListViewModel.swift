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
    @Published var showCreateForm = false
    
    @Published var selectedStatus: TaskStatus = .all
    @Published var sortingBy: SortingCriteria = .creationDate
    
    @Published private(set) var tasks: [TaskModel] = []
    @Published private(set) var filteredTasks: [TaskModel] = []
    
    private let repository: TasksRepository
    
    // MARK: Init
    
    init(repository: TasksRepository = TasksFirebaseRepository()) {
        self.repository = repository
        
        setupBindings()
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
                dueDate: task.dueDate,
                creationDate: task.creationDate
            )
            try await repository.updateTask(modifiedTask)
            
            // Refresh data
            await fetchAllTasks()
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: Private methods
    
    private func setupBindings() {
        Publishers.CombineLatest4($tasks, $selectedStatus, $searchText, $sortingBy)
            .map { tasks, selectedStatus, searchText, sortingBy in
                tasks.filter { task in
                    (selectedStatus == .all || task.statusType == selectedStatus) &&
                    (searchText.isEmpty || (task.title ?? "").lowercased().contains(searchText.lowercased()))
                }
                .sorted { first, second in
                    switch sortingBy {
                        case .creationDate:
                            return (first.creationDate ?? Date()) > (second.creationDate ?? Date())
                            
                        case .title:
                            return (first.title ?? "") < (second.title ?? "")
                            
                        case .dueDate:
                            return (first.dueDate ?? Date()) < (second.dueDate ?? Date())
                    }
                }
            }
            .assign(to: &$filteredTasks)
    }
}
