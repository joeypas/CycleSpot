//
//  LoginViewModel.swift
//  CycleSpot
//
//  Created by Joseph Liotta on 11/19/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    @Published var user_handle: User? = nil
    @Published var isSignedIn: Bool = false
    @Published var user_profile: UserProfile? = nil
    
    init() {
        self.user_handle = Auth.auth().currentUser
        self.isSignedIn = user_handle != nil
    }
    
    func signUp(email: String,  password: String) {
        let db = Firestore.firestore()
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error)
                return
            }
            
            self.user_handle = result?.user
            self.isSignedIn = true
            
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {result, error in
            if let error = error {
                print(error)
                return
            }
            self.user_handle = result?.user
            self.isSignedIn = true
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user_handle = nil
            self.isSignedIn = false
        } catch {
            return
        }
    }
}
