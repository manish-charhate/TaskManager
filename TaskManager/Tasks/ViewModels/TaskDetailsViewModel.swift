//
//  TaskDetailsViewModel.swift
//  TaskManager
//
//  Created by Manish Charhate on 22/06/24.
//

import Foundation

@MainActor
final class TaskDetailsViewModel: ObservableObject {
    
    // MARK: Properties
    
    @Published var title = ""
    @Published var description = ""
    @Published var dueDate = Date()
    @Published var taskStatus = TaskStatus.todo
    @Published var showError = false
    @Published private(set) var isEditing = false
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage = ""
    @Published private(set) var editButtonTitle = "Edit"
    
    private let repository: TaskDetailsRepository
    private let notificationManager: LocalNotificationManager
    let originalTask: TaskModel
    
    // MARK: Init
    
    init(
        task: TaskModel,
        repository: TaskDetailsRepository = TaskDetailsFirebaseRepository(),
        notificationManager: LocalNotificationManager
    ) {
        self.originalTask = task
        self.title = task.title ?? ""
        self.description = task.description ?? ""
        self.dueDate = task.dueDate ?? Date()
        self.taskStatus = task.statusType
        self.isEditing = false
        self.repository = repository
        self.notificationManager = notificationManager
    }
    
    // MARK: Public methods
    
    func toggleEditingMode() {
        // If task is in editing mode then update the details and change to read-only mode
        if isEditing {
            Task {
                await updateTaskDetails()
            }
        } else {
            // If task is in read-only mode then change it to editing mode
            changeEditingMode()
        }
    }
    
    func updateTaskDetails() async {
        let modifiedTask = TaskModel(
            id: originalTask.id,
            title: title,
            description: description,
            status: taskStatus.rawValue,
            dueDate: dueDate,
            creationDate: originalTask.creationDate
        )
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            try await repository.updateTaskDetails(modifiedTask: modifiedTask)
            
            // Update local notification
            updateLocalNotification(for: modifiedTask)
            
            changeEditingMode()
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func updateTaskStatus(_ status: TaskStatus) async {
        let modifiedTask = TaskModel(
            id: originalTask.id,
            title: originalTask.title,
            description: originalTask.description,
            status: status.rawValue,
            dueDate: originalTask.dueDate,
            creationDate: originalTask.creationDate
        )
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            try await repository.updateTaskDetails(modifiedTask: modifiedTask)
            taskStatus = status
            
            if status == .done {
                removeLocalNotification(for: modifiedTask.id)
            } else {
                updateLocalNotification(for: modifiedTask)
            }
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteTask() async -> Bool {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            try await repository.deleteTask(originalTask.id)
            
            // Remove local notification
            removeLocalNotification(for: originalTask.id)
            
            return true
        } catch {
            showError = true
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    // MARK: Private methods
    
    private func changeEditingMode() {
        isEditing.toggle()
        editButtonTitle = isEditing ? "Done" : "Edit"
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
