//
//  OnboardingViewModelTests.swift
//  TaskManagerTests
//
//  Created by Manish Charhate on 21/06/24.
//

import XCTest
@testable import TaskManager

@MainActor
final class OnboardingViewModelTests: XCTestCase {
    
    var viewModel: OnboardingViewModel!
    var mockRepository: MockOnboardingRepository!

    override func setUpWithError() throws {
        mockRepository = MockOnboardingRepository()
        viewModel = OnboardingViewModel(repository: mockRepository)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockRepository = nil
    }

    func testInitialization() {
        XCTAssertFalse(viewModel.showError)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "")
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
    }
    
    func testSignUpWithEmptyEmailAndPassword() async {
        viewModel.email = ""
        viewModel.password = ""
        
        await viewModel.signUp()
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Email ID or password is invalid")
    }

    func testSignUpWithValidEmailAndPasswordSuccess() async {
        viewModel.email = "test@example.com"
        viewModel.password = "password"
        
        await viewModel.signUp()
        
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(mockRepository.signUpCalled)
        XCTAssertEqual(UserDefaults.standard.bool(forKey: "showOnboarding"), false)
    }
    
    func testSignUpWithValidEmailAndPasswordFailure() async {
        viewModel.email = "test@example.com"
        viewModel.password = "password"
        mockRepository.shouldReturnError = true
        
        await viewModel.signUp()
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, mockRepository.signUpError)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(mockRepository.signUpCalled)
    }
    
    func testSignInWithEmptyEmailAndPassword() async {
        viewModel.email = ""
        viewModel.password = ""
        
        await viewModel.signIn()
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Email ID or password is invalid")
    }

    func testSignInWithValidEmailAndPasswordSuccess() async {
        viewModel.email = "test@example.com"
        viewModel.password = "password"
        
        await viewModel.signIn()
        
        XCTAssertFalse(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(mockRepository.signInCalled)
        XCTAssertEqual(UserDefaults.standard.bool(forKey: "showOnboarding"), false)
    }
    
    func testSignInWithValidEmailAndPasswordFailure() async {
        viewModel.email = "test@example.com"
        viewModel.password = "password"
        mockRepository.shouldReturnError = true
        
        await viewModel.signIn()
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, mockRepository.signInError)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(mockRepository.signInCalled)
    }
}
