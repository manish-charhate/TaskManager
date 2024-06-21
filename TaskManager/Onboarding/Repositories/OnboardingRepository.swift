//
//  OnboardingRepository.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import Foundation

protocol OnboardingRepository {
    
    func signUp(
        with email: String,
        password: String
    ) async throws -> OnboardingResponse
    
    func signIn(
        with email: String,
        password: String
    ) async throws -> OnboardingResponse
}
