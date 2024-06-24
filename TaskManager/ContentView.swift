//
//  ContentView.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import SwiftUI

enum TabType {
    case tasks
    case profile
}

struct ContentView: View {
    
    @AppStorage("showOnboarding") var showOnboarding = true
    
    @State private var selectedTab = TabType.tasks
    
    private let notificationManager = LocalNotificationManager()
    
    var body: some View {
        Group {
            if showOnboarding {
                NavigationStack {
                    OnboardingView(
                        viewModel: OnboardingViewModel(
                            repository: OnboardingFirebaseRepository()
                        )
                    )
                }
            } else {
                TabView(selection: $selectedTab) {
                    TaskListView(
                        viewModel: TaskListViewModel(
                            notificationManager: notificationManager
                        )
                    )
                    .tabItem {
                        Label("Tasks", systemImage: "list.clipboard")
                    }
                    .tag(TabType.tasks)
                    
                    ProfileTabView(
                        selectedTab: $selectedTab,
                        viewModel: ProfileViewModel(
                            repository: ProfileFirebaseRepository()
                        )
                    )
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(TabType.profile)
                }
                .task {
                    await notificationManager.requestNotificationPermission()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
