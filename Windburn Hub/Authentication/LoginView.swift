//
//  LoginView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-27.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Log In").font(.largeTitle).bold()

            TextField("Email", text: $email).textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Log In") {
                authViewModel.logIn(email: email, password: password)
            }

            NavigationLink("Don't have an account? Sign Up", destination: SignUpView())
        }
        .padding()
    }
}
