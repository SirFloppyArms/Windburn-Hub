//
//  SignUpView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-27.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var selectedRole = "athlete"
    @State private var rolePassword = ""

    @State private var errorMessage = ""
    @State private var showError = false

    let roles = ["athlete", "coach"] // Only show athlete and coach

    // Secret keys — keep these hidden and safe
    let coachKey = "wb-COACH-2739-secure"
    let adminKey = "wb-ADMIN-9041-lock"

    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.largeTitle)
                .bold()

            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Picker("Select Role", selection: $selectedRole) {
                ForEach(roles, id: \.self) { role in
                    Text(role.capitalized)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            // Only show password field if user selects coach
            if selectedRole == "coach" {
                SecureField("Enter Coach Access Password", text: $rolePassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Button("Sign Up") {
                signUpTapped()
            }
            .padding()

            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }

    func signUpTapped() {
        var finalRole = selectedRole

        // Handle role password check if "coach" is selected
        if selectedRole == "coach" {
            if rolePassword == adminKey {
                // It's an admin — treat them like an athlete in UI
                finalRole = "admin"
            } else if rolePassword == coachKey {
                finalRole = "coach"
            } else {
                errorMessage = "Incorrect coach password"
                showError = true
                return
            }
        }

        errorMessage = ""
        showError = false

        // Save role (including secret admin role)
        authViewModel.signUp(email: email, password: password, name: name, role: finalRole)
    }
}
