//
//  CreateTaskViewModel.swift
//  TaskManager
//
//  Created by Manish Charhate on 22/06/24.
//

import Foundation

@MainActor
final class CreateTaskViewModel: ObservableObject {
    
    // MARK: Properties
    
    @Published var taskTitle: String = ""
    @Published var taskDescription: String = ""
    @Published var currentStatus: TaskStatus = .todo
    @Published var dueDate: Date = Date()
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let repository: TasksRepository
    private let notificationManager: LocalNotificationManager
    
    // MARK: Init
    
    init(
        repository: TasksRepository = TasksFirebaseRepository(),
        notificationManager: LocalNotificationManager
    ) {
        self.repository = repository
        self.notificationManager = notificationManager
    }
    
    // MARK: Public methods
    
    func createTask() async -> Bool {
        guard !taskTitle.isEmpty else {
            showError = true
            errorMessage = "Please add title for the task"
            return false
        }
        
        let task = TaskModel(
            id: UUID().uuidString,
            title: taskTitle,
            description: taskDescription,
            status: currentStatus.rawValue,
            dueDate: dueDate,
            creationDate: Date()
        )
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            try await repository.createTask(task)
            
            // Add local notification for the task
            addLocalNotification(for: task)
            
            return true
        } catch {
            showError = true
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    // MARK: Private methods
    
    private func addLocalNotification(for task: TaskModel) {
        Task {
            do {
                // Schedule local reminder on due date
                try await notificationManager.scheduleLocalNotificationWith(
                    id: task.id,
                    title: task.title ?? "",
                    on: task.dueDate ?? Date()
                )
                print("hello")
            } catch {
                print("Failed to schedule local notification: \(error.localizedDescription)")
            }
        }
    }
}
