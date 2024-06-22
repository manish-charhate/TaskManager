//
//  TaskDetailsFirebaseRepository.swift
//  TaskManager
//
//  Created by Manish Charhate on 22/06/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class TaskDetailsFirebaseRepository: TaskDetailsRepository {
    
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
    
    func updateTaskDetails(modifiedTask: TaskModel) async throws {
        try tasksRef.document(modifiedTask.id).setData(from: modifiedTask, merge: true)
    }
    
    func deleteTask(_ taskId: String) async throws {
        try await tasksRef.document(taskId).delete()
    }
}
