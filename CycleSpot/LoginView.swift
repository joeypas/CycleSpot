//
//  LoginView.swift
//  CycleSpot
//
//  Created by Joseph Liotta on 11/19/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            if viewModel.isSignedIn {
                SettingsView(user: viewModel.user_profile)
            } else {
                
            }
        }
    }
}

#Preview {
    LoginView()
}
