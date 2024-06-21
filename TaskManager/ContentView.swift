//
//  ContentView.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("showOnboarding") var showOnboarding = true
    
    var body: some View {
        Group {
            if showOnboarding {
                OnboardingView(
                    viewModel: OnboardingViewModel()
                )
            } else {
                TaskListView(viewModel: TaskListViewModel())
            }
        }
    }
}

#Preview {
    ContentView()
}
