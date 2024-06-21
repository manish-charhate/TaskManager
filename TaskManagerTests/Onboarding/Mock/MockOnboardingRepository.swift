//
//  MockOnboardingRepository.swift
//  TaskManagerTests
//
//  Created by Manish Charhate on 21/06/24.
//

import Foundation
@testable import TaskManager

final class MockOnboardingRepository: OnboardingRepository {
    
    var shouldReturnError = false
    var signUpCalled = false
    var signInCalled = false
    var signUpError = "Mock SignUp Error"
    var signInError = "Mock SignUp Error"
    
    func signUp(with email: String, password: String) async throws -> OnboardingResponse {
        signUpCalled = true
        
        if shouldReturnError {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: signUpError])
        }
        
        return OnboardingResponse(
            uid: UUID().uuidString,
            email: email,
            photoURL: URL(string: "http://photo-url.com"),
            displayName: "Test 1"
        )
    }
    
    func signIn(with email: String, password: String) async throws -> OnboardingResponse {
        signInCalled = true
        
        if shouldReturnError {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: signInError])
        }
        
        return OnboardingResponse(
            uid: UUID().uuidString,
            email: email,
            photoURL: URL(string: "http://photo-url.com"),
            displayName: "Test 1"
        )
    }
}
