//
//  OnboardingViewModel.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import Combine
import Foundation

@MainActor
final class OnboardingViewModel: ObservableObject {
    
    // MARK: Properties
    
    private let repository: OnboardingRepository
    
    @Published var email = ""
    @Published var password = ""
    @Published private(set) var errorMessage = ""
    @Published var showError = false
    @Published private(set) var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Init
    
    init(repository: OnboardingRepository = OnboardingFirebaseRepository()) {
        self.repository = repository
    }
    
    // MARK: Public methods
    
    func signUp() async {
        guard !email.isEmpty, !password.isEmpty else {
            showError = true
            errorMessage = "Email ID or password is invalid"
            return
        }
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let response = try await repository.signUp(with: email, password: password)
            UserDefaults.standard.set(false, forKey: "showOnboarding")
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func signIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            showError = true
            errorMessage = "Email ID or password is invalid"
            return
        }
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let response = try await repository.signIn(with: email, password: password)
            UserDefaults.standard.set(false, forKey: "showOnboarding")
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
}
