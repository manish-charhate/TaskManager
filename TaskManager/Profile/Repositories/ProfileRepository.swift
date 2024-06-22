//
//  ProfileRepository.swift
//  TaskManager
//
//  Created by Manish Charhate on 22/06/24.
//

import Foundation

protocol ProfileRepository {
    
    func fetchProfile() -> Profile?
    
    func logout() throws
    
    func deleteAccount() async throws
}
