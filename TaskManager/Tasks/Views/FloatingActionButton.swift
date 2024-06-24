//
//  FloatingActionButton.swift
//  TaskManager
//
//  Created by Manish Charhate on 23/06/24.
//

import SwiftUI

struct FloatingActionButton: View {
    
    let actionHandler: () -> Void
    
    var body: some View {
        Button(action: actionHandler) {
            Image(systemName: "plus")
                .font(.title.weight(.semibold))
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(color: Color(UIColor.systemGray3), radius: 4, x: 0, y: 4)
        }
        .padding()
    }
}

#Preview {
    FloatingActionButton(actionHandler: {})
}
