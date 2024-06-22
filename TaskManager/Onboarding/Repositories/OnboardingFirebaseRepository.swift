//
//  OnboardingFirebaseRepository.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import Foundation
import FirebaseAuth

final class OnboardingFirebaseRepository: OnboardingRepository {
    
    func signUp(
        with email: String,
        password: String
    ) async throws -> Profile {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return Profile(user: authResult.user)
    }
    
    func signIn(
        with email: String,
        password: String
    ) async throws -> Profile {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return Profile(user: authResult.user)
    }
}
