//
//  ProfileFirebaseRepository.swift
//  TaskManager
//
//  Created by Manish Charhate on 22/06/24.
//

import Foundation
import FirebaseAuth

final class ProfileFirebaseRepository: ProfileRepository {
    
    func fetchProfile() -> Profile? {
        guard let authResult = Auth.auth().currentUser else { return nil }
        return Profile(user: authResult)
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    func deleteAccount() async throws {
        let user = Auth.auth().currentUser
        
        try await user?.delete()
    }
}
