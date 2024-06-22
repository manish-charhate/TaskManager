//
//  TaskDetailsView.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import SwiftUI

struct TaskDetailsView: View {
    
    @ObservedObject var viewModel: TaskDetailsViewModel
    @Binding var navigationPath: NavigationPath
    
    var titleSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Title:")
                .font(.headline)
                .fontWeight(.bold)
            
            if viewModel.isEditing {
                TextField("Task Title", text: $viewModel.title, axis: .vertical)
                    .lineLimit(1...10)
                    .font(.body)
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
            } else {
                Text(viewModel.title)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    var taskStatusField: some View {
        HStack {
            StatusView(status: viewModel.taskStatus)
            
            Menu {
                ForEach(TaskStatus.allCases.dropFirst(), id: \.self) { status in
                    Button {
                        Task {
                            await viewModel.updateTaskStatus(status)
                        }
                    } label: {
                        Text(status.rawValue.capitalized)
                    }
                }
            } label: {
                Image(systemName: "chevron.down.circle")
                    .font(.title2)
            }
        }
    }
    
    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Description:")
                .font(.headline)
                .fontWeight(.bold)
            
            if viewModel.isEditing {
                TextField("Task Description", text: $viewModel.description, axis: .vertical)
                    .lineLimit(1...50)
                    .font(.body)
                    .padding()
                    .background(.white)
                    .cornerRadius(10)
                
            } else {
                Text(viewModel.description)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                
                titleSection

                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Status:")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        taskStatusField
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        Text("Due Date:")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        if viewModel.isEditing {
                            DatePicker("", selection: $viewModel.dueDate, displayedComponents: .date)
                        } else {
                            Text(viewModel.dueDate, style: .date)
                                .font(.body)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                descriptionSection
                
                if !viewModel.isEditing {
                    Button {
                        Task {
                            if await viewModel.deleteTask() {
                                // Pop to root view if delete operation succeeds
                                navigationPath.removeLast()
                            }
                        }
                    } label: {
                         Text("Delete Task")
                            .font(.subheadline)
                            .padding()
                            .foregroundColor(.white)
                            .background(.red)
                            .cornerRadius(10.0)
                    }
                    .padding()
                    
                }

                Spacer()
            }
            .disabled(viewModel.isLoading)
            
            if viewModel.isLoading {
               ProgressView()
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Button {
                withAnimation {
                    viewModel.toggleEditingMode()
                }
            } label: {
                Text(viewModel.editButtonTitle)
            }
        )
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text("Error!"), message: Text(viewModel.errorMessage))
        }
    }
}

#Preview {
    NavigationStack {
        TaskDetailsView(
            viewModel: TaskDetailsViewModel(
                task: TaskModel(
                    id: UUID().uuidString,
                    title: "Task 1",
                    description: "description",
                    status: TaskStatus.done.rawValue,
                    dueDate: Date()
                )
            ),
            navigationPath: .constant(NavigationPath())
        )
    }
}
