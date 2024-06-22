//
//  PersonInfoRow.swift
//  TaskManager
//
//  Created by Manish Charhate on 22/06/24.
//

import SwiftUI

struct PersonInfoRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.gray)
        }
    }
}
