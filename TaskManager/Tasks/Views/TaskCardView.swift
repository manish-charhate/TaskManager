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
                
                Text(task.title)
                    .font(.headline)
                
                Text(task.description)
                    .font(.body)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Image(systemName: "clock")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(task.dueDate, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                StatusView(status: task.status)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    TaskCardView(
        task: TaskModel(
            title: "Task 1",
            description: "Description 1",
            status: .todo,
            dueDate: Date()
        )
    )
}
