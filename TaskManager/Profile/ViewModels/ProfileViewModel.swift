//
//  ProfileViewModel.swift
//  TaskManager
//
//  Created by Manish Charhate on 22/06/24.
//

import Foundation

enum ProfileAlertType {
    case logout
    case error
}

@MainActor
final class ProfileViewModel: ObservableObject {
    
    // MARK: Properties
    
    @Published var isLoading = false
    
    @Published var showAlert = false
    @Published private(set) var errorMessage = ""
    @Published private(set) var alertType: ProfileAlertType = .logout
    @Published private(set) var profile: Profile = Profile(uid: "", email: nil, photoURL: nil, displayName: nil)
    
    private let repository: ProfileRepository
    
    init(repository: ProfileRepository = ProfileFirebaseRepository()) {
        self.repository = repository
    }
    
    func fetchProfile() {
        if let profile = repository.fetchProfile() {
            self.profile = profile
        }
    }
    
    func logout() {
        do {
            try repository.logout()
            UserDefaults.standard.set(true, forKey: "showOnboarding")
        } catch {
            alertType = .error
            errorMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    func handleLogoutButtonTap() {
        alertType = .logout
        showAlert = true
    }
}
