//
//  OnboardingResponse.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import Foundation
import FirebaseAuth

struct OnboardingResponse {
    let uid: String
    let email: String?
    let photoURL: URL?
    let displayName: String?
}

extension OnboardingResponse {
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL
        self.displayName = user.displayName
    }
}
