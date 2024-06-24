//
//  TasksEmptyStateView.swift
//  TaskManager
//
//  Created by Manish Charhate on 23/06/24.
//

import SwiftUI

struct TasksEmptyStateView: View {
    
    let actionHandler: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "clipboard")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 64)
                .foregroundColor(.gray)
            
            Text("No tasks found")
                .font(.headline)
                .foregroundStyle(.gray)
            
            Button(action: actionHandler) {
                Text("Create Task")
                    .padding(EdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0))
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10.0)
            }
            .padding()
            
            Spacer()
        }
    }
}

#Preview {
    TasksEmptyStateView(actionHandler: {})
}
