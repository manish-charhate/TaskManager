//
//  ProfileTabView.swift
//  TaskManager
//
//  Created by Manish Charhate on 22/06/24.
//

import SwiftUI

struct ProfileTabView: View {

    // MARK: Public properties

    @Binding var selectedTab: TabType
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 32.0) {
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 120, height: 120)
                
                VStack(spacing: 16.0) {
                    PersonInfoRow(title: "Email", value: viewModel.profile.email ?? "")
                }
                .padding()
                
                Button(action: {
                    viewModel.handleLogoutButtonTap()
                }) {
                    Text("Logout")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .padding(EdgeInsets(top: 12.0, leading: 8.0, bottom: 12.0, trailing: 8.0))
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(EdgeInsets(top: 64.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
            .alert(isPresented: $viewModel.showAlert) {
                switch viewModel.alertType {
                    case .logout:
                        return Alert(
                            title: Text("Logout"),
                            message: Text("Are you sure you want to logout?"),
                            primaryButton: .default(Text("Logout")) {
                                viewModel.logout()
                                selectedTab = .tasks
                            },
                            secondaryButton: .cancel()
                        )
                        
                    case .error:
                        return Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
                }
            }
            
            // Show loader
            if viewModel.isLoading {
                ZStack {
                    ProgressView().progressViewStyle(.circular)
                }
            }
        }
        .onAppear {
            viewModel.fetchProfile()
        }
    }
}
