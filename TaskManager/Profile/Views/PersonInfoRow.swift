//
//  PersonInfoRow.swift
//  TaskManager
//
//  Created by Manish Charhate on 22/06/24.
//

import SwiftUI

struct PersonInfoRow: View {
    
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            
            Text(value)
                .foregroundColor(.gray)
        }
    }
}
