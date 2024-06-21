//
//  StatusView.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import Foundation
import SwiftUI

struct StatusView: View {
    
    var status: TaskStatus

    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.footnote)
            .fontWeight(.semibold)
            .padding(5)
            .background(statusColor)
            .foregroundColor(.white)
            .cornerRadius(5)
    }

    private var statusColor: Color {
        switch status {
            case .todo:
                return .red
                
            case .inProgress:
                return .orange
                
            case .done:
                return .green
                
            case .all:
                return .clear
        }
    }
}

#Preview {
    StatusView(status: .inProgress)
}
