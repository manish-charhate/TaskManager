//
//  Firestore+Extension.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import Foundation
import FirebaseFirestore

extension Firestore {
    
    func getDocuments(
        from collection: CollectionReference
    ) async throws -> [QueryDocumentSnapshot] {
        return try await withCheckedThrowingContinuation { continuation in
            collection.getDocuments { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let snapshot = snapshot {
                    continuation.resume(returning: snapshot.documents)
                } else {
                    continuation.resume(returning: [])
                }
            }
        }
    }
}
