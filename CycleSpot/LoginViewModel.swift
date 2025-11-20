//
//  LoginViewModel.swift
//  CycleSpot
//
//  Created by Joseph Liotta on 11/19/25.
//

import SwiftUI
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isSignedIn: Bool = false
    
    init() {
        self.user = Auth.auth().currentUser
        self.isSignedIn = user != nil
    }
    
    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                return
            }
            self.user = result?.user
            self.isSignedIn = true
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {result, error in
            if let error = error {
                return
            }
            self.user = result?.user
            self.isSignedIn = true
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isSignedIn = false
        } catch {
            return
        }
    }
}
