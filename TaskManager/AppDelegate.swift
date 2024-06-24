//
//  AppDelegate.swift
//  TaskManager
//
//  Created by Manish Charhate on 21/06/24.
//

import UIKit
import Foundation
import FirebaseCore
import FirebaseAuth

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Configure Firebase app
        FirebaseApp.configure()
        
        return true
    }
}
