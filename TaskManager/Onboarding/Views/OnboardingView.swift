//
//  OnboardingView.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.teal)
                        
                        Text("TaskManager")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.bottom, 40)
                    
                    VStack(spacing: 20) {
                        TextField("Email", text: $viewModel.email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 20) {
                        Button(action: signUp) {
                            Text("Sign Up")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.isLoading)
                        
                        Button(action: signIn) {
                            Text("Sign In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.isLoading)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                }
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .padding()
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text(
                    "Error!"
                ),
                message: Text(
                    viewModel.errorMessage
                ),
                dismissButton: .default(
                    Text(
                        "Okay"
                    )
                )
            )
        }
    }
    
    private func signIn() {
        Task {
            await viewModel.signIn()
        }
    }
    
    private func signUp() {
        Task {
            await viewModel.signUp()
        }
    }
}

#Preview {
    OnboardingView(
        viewModel: OnboardingViewModel(
            repository: OnboardingFirebaseRepository()
        )
    )
}
