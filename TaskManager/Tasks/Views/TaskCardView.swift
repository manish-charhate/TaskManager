//
//  TaskCardView.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import Foundation
import SwiftUI

struct TaskCardView: View {
    
    let task: TaskModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                
                Text(task.title ?? "")
                    .font(.headline)
                
                Text(task.description ?? "")
                    .font(.body)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Image(systemName: "clock")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(task.dueDate ?? Date(), style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                StatusView(status: task.statusType)
            }
            
            Spacer()
        }
    }
}

#Preview {
    TaskCardView(
        task: TaskModel(
            id: UUID().uuidString,
            title: "Task 1",
            description: "Description 1",
            status: TaskStatus.todo.rawValue,
            dueDate: Date()
        )
    )
}
