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
    @Published var showCreateForm = false
    @Published private(set) var errorMessage = ""
    @Published private(set) var showError = false
    @Published private(set) var isLoading = false
    
    @Published var selectedStatus: TaskStatus = .all
    @Published var sortingBy: SortingCriteria = .creationDate
    
    @Published private var tasks: [TaskModel] = []
    @Published private(set) var filteredTasks: [TaskModel] = []
    
    let notificationManager: LocalNotificationManager
    private let repository: TasksRepository
    
    // MARK: Init
    
    init(
        repository: TasksRepository = TasksFirebaseRepository(),
        notificationManager: LocalNotificationManager
    ) {
        self.repository = repository
        self.notificationManager = notificationManager
        
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
            
            // Remove pending notification
            removeLocalNotification(for: task.id)
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
            
            if status == .done {
                removeLocalNotification(for: modifiedTask.id)
            } else {
                updateLocalNotification(for: modifiedTask)
            }
            
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
                            // Sort tasks in descending order of creation date to show recently created task at top
                            return (first.creationDate ?? Date()) > (second.creationDate ?? Date())
                            
                        case .title:
                            // Sort tasks alphabetically
                            return (first.title ?? "") < (second.title ?? "")
                            
                        case .dueDate:
                            // Sort tasks in ascending order of due date to show nearest due tasks first
                            return (first.dueDate ?? Date()) < (second.dueDate ?? Date())
                    }
                }
            }
            .assign(to: &$filteredTasks)
    }
    
    private func updateLocalNotification(for task: TaskModel) {
        // Remove previously scheduled notification
        removeLocalNotification(for: task.id)
        
        // Schedule new notification with updated content
        addLocalNotification(for: task)
    }
    
    private func removeLocalNotification(for taskId: String) {
        notificationManager.removePendingNotification(for: taskId)
    }
    
    private func addLocalNotification(for task: TaskModel) {
        Task {
            do {
                // Schedule local reminder on due date
                try await notificationManager.scheduleLocalNotificationWith(
                    id: task.id,
                    title: task.title ?? "",
                    on: task.dueDate ?? Date()
                )
            } catch {
                print("Failed to schedule local notification: \(error.localizedDescription)")
            }
        }
    }
}
