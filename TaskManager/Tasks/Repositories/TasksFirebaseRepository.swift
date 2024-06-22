//
//  TasksFirebaseRepository.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class TasksFirebaseRepository: TasksRepository {
    
    // MARK: Properties
    
    private let userRef: DocumentReference
    private let tasksRef: CollectionReference
    
    // MARK: Init
    
    init() {
        let db = Firestore.firestore()
        let collectionRef = db.collection("TasksCollection")
        let userId = Auth.auth().currentUser?.uid ?? ""
        userRef = collectionRef.document(userId)
        tasksRef = userRef.collection("tasks")
    }
    
    // MARK: TasksRepository Impl
    
    func createTask(_ task: TaskModel) async throws {
        try tasksRef.document(task.id).setData(from: task)
    }
    
    func fetchTasks() async throws -> [TaskModel] {
        let documents = try await tasksRef.order(by: "creationDate", descending: true).getDocuments().documents
        
        return documents.compactMap { snapshot in
            do {
                let taskModel = try snapshot.data(as: TaskModel.self)
                return taskModel
            } catch {
                print("Error: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    func updateTask(_ task: TaskModel) async throws {
        try tasksRef.document(task.id).setData(from: task, merge: true)
    }
    
    func deleteTask(_ task: TaskModel) async throws {
        try await tasksRef.document(task.id).delete()
    }
}
