//
//  TaskListView.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import SwiftUI

struct TaskListView: View {
    
    @ObservedObject var viewModel: TaskListViewModel
    @State var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                if !viewModel.isLoading && viewModel.filteredTasks.isEmpty  {
                    TasksEmptyStateView {
                        viewModel.showCreateForm.toggle()
                    }
                } else {
                    ZStack(alignment: .bottomTrailing) {
                        List(viewModel.filteredTasks) { task in
                            NavigationLink(value: task) {
                                TaskCardView(task: task)
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            Task {
                                                await viewModel.deleteTask(task)
                                            }
                                        } label: {
                                            Label {
                                                Text("Delete")
                                            } icon: {
                                                Image(systemName: "trash")
                                            }
                                        }
                                        
                                        Button {
                                            Task {
                                                await viewModel.updateStatus(to: .done, for: task)
                                            }
                                        } label: {
                                            Label {
                                                Text("Done")
                                            } icon: {
                                                Image(systemName: "checkmark.square.fill")
                                            }
                                        }
                                        .tint(.green)
                                    }
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(10)
                            .shadow(color: Color(UIColor.systemGray3), radius: 4)
                        }
                        .listStyle(PlainListStyle())
                        
                        FloatingActionButton {
                            viewModel.showCreateForm.toggle()
                        }
                    }
                }
            }
            .navigationTitle("Task Manager")
            .searchable(text: $viewModel.searchText)
            .toolbar {
                sortButton
                filterButton
            }
            .navigationDestination(for: TaskModel.self) { model in
                TaskDetailsView(
                    viewModel: TaskDetailsViewModel(
                        task: model,
                        notificationManager: viewModel.notificationManager
                    ),
                    navigationPath: $navigationPath
                )
            }
            .task {
                await viewModel.fetchAllTasks()
            }
            .fullScreenCover(isPresented: $viewModel.showCreateForm) {
                Task {
                    await viewModel.fetchAllTasks()
                }
            } content: {
                CreateTaskFormView(
                    viewModel: CreateTaskViewModel(notificationManager: viewModel.notificationManager),
                    showForm: $viewModel.showCreateForm
                )
            }
        }
    }
    
    var sortButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Menu {
                Picker("Sort By", selection: $viewModel.sortingBy) {
                    ForEach(SortingCriteria.allCases, id: \.self) { type in
                        Text("Sort by: \(type.rawValue.capitalized)").tag(type)
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down.circle")
                    .imageScale(.large)
            }
        }
    }
    
    var filterButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker("Filter By", selection: $viewModel.selectedStatus) {
                    ForEach(TaskStatus.allCases, id: \.self) { status in
                        Text(status.rawValue.capitalized).tag(status)
                    }
                }
            } label: {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .imageScale(.large)
            }
        }
    }
}

#Preview {
    TaskListView(viewModel: TaskListViewModel(notificationManager: LocalNotificationManager()))
}
