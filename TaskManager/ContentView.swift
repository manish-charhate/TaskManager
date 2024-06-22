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
    
    var body: some View {
        Group {
            if showOnboarding {
                NavigationStack {
                    OnboardingView(
                        viewModel: OnboardingViewModel()
                    )
                }
            } else {
                TabView(selection: $selectedTab) {
                    TaskListView(viewModel: TaskListViewModel())
                        .tabItem {
                            Label("Tasks", systemImage: "list.clipboard")
                        }
                        .tag(TabType.tasks)
                    
                    ProfileTabView(selectedTab: $selectedTab, viewModel: ProfileViewModel())
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                        .tag(TabType.profile)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
