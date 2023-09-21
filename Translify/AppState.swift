//
//  AppState.swift
//  Translify
//
//  Created by Daniel Gabriel on 20/09/23.
//

import Foundation
import FirebaseAuth
import Firebase
import SwiftUI

class AppState: ObservableObject {
    
    @Published var currentUser: User?
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    var userEmail: String? {
            return currentUser?.email
        }
    
    init() {
        FirebaseApp.configure()
        
        if let currentUser = Auth.auth().currentUser {
            self.currentUser = currentUser
        }
    }
}
