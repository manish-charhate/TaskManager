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
    private(set) var originalTask: TaskModel
    
    // MARK: Init
    
    init(
        task: TaskModel,
        repository: TaskDetailsRepository = TaskDetailsFirebaseRepository()
    ) {
        self.originalTask = task
        self.title = task.title ?? ""
        self.description = task.description ?? ""
        self.dueDate = task.dueDate ?? Date()
        self.taskStatus = task.statusType
        self.isEditing = false
        self.repository = repository
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
            return true
        } catch {
            showError = true
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    // MARK: Private methods
    
    func changeEditingMode() {
        isEditing.toggle()
        editButtonTitle = isEditing ? "Done" : "Edit"
    }
}
