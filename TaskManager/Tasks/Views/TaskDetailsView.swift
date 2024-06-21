//
//  TaskDetailView.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import Foundation
import SwiftUI

struct TaskDetailsView: View {
    
    let task: TaskModel
    
    var body: some View {
        Text(task.title)
    }
}

#Preview {
    TaskDetailsView(
        task: TaskModel(
            title: "Task 1",
            description: "descriptio ",
            status: .done,
            dueDate: Date()
        )
    )
}
