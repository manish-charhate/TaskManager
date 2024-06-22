//
//  CreateTaskFormView.swift
//  TaskManager
//
//  Created by Manish Charhate on 22/06/24.
//

import Foundation
import SwiftUI

struct CreateTaskFormView: View {
    
    @ObservedObject var viewModel: CreateTaskViewModel
    @Binding var showForm: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Title", text: $viewModel.taskTitle, axis: .vertical)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    TextField("Task Description", text: $viewModel.taskDescription, axis: .vertical)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                Section(header: Text("Status")) {
                    Picker("Current Status", selection: $viewModel.currentStatus) {
                        ForEach(TaskStatus.allCases.dropFirst(), id: \.self) { status in
                            Text(status.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section {
                    DatePicker("Due Date", selection: $viewModel.dueDate, displayedComponents: .date)
                }
                
                Section {
                    Button(action: saveTask) {
                        Text("Create Task")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .navigationTitle("Create Task")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showForm = false
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .alert(isPresented: $viewModel.showError) {
                Alert(title: Text("Error!"), message: Text(viewModel.errorMessage))
            }
        }
    }
    
    private func saveTask() {
        Task {
            if await viewModel.createTask() {
                showForm = false
            }
        }
    }
}

#Preview {
    CreateTaskFormView(viewModel: CreateTaskViewModel(), showForm: .constant(true))
}
