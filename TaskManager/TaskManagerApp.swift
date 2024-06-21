//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
