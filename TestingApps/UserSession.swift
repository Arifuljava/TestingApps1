//
//  UserSession.swift
//  TestingApps
//
//  Created by sang on 13/5/24.
//

import Foundation
class UserSession {
    
    // Singleton instance
    static let shared = UserSession()
    
    // User properties
    private(set) var userId: String?
    private(set) var email: String?
    private(set) var displayName: String?
    private(set) var isLoggedIn: Bool = false
    
    private init() {}
    
    // Login user
    func login(userId: String, email: String, displayName: String? = nil) {
        self.userId = userId
        self.email = email
        self.displayName = displayName
        self.isLoggedIn = true
    }
    
    // Logout user
    func logout() {
        self.userId = nil
        self.email = nil
        self.displayName = nil
        self.isLoggedIn = false
    }
}
