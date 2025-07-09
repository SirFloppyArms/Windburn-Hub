//
//  SignUpView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-27.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var selectedRole = "athlete"
    @State private var rolePassword = ""
    @State private var selectedProfileImage = "run1"

    @State private var errorMessage = ""
    @State private var showError = false

    let roles = ["athlete", "coach"]
    let coachKey = "wb-COACH-2739-secure"
    let adminKey = "wb-ADMIN-9041-lock"

    let profileImageOptions = ["run1", "run2", "run3", "bike1", "bike2", "swim1", "windburn_old", "swim3", "winner", "windburn", "tri", "runswim", "podium", "finisher", "strong"]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 40)

                Image("windburn")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)

                Text("Create Account")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(WindburnColors.primary)

                WindburnTextField(placeholder: "Name", text: $name)
                WindburnTextField(placeholder: "Email", text: $email)
                WindburnTextField(placeholder: "Password", text: $password, isSecure: true)

                Picker("Select Role", selection: $selectedRole) {
                    ForEach(roles, id: \.self) { role in
                        Text(role.capitalized)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                if selectedRole == "coach" {
                    WindburnTextField(placeholder: "Enter Coach Access Password", text: $rolePassword, isSecure: true)
                }

                Text("Choose Profile Picture")
                    .font(.headline)
                    .padding(.top, 8)

                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 12) {
                    ForEach(profileImageOptions, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(imageName == selectedProfileImage ? WindburnColors.primary : Color.clear, lineWidth: 3)
                            )
                            .shadow(radius: imageName == selectedProfileImage ? 5 : 0)
                            .onTapGesture {
                                selectedProfileImage = imageName
                            }
                    }
                }

                WindburnButton(title: "Sign Up") {
                    signUpTapped()
                }

                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }

                Spacer(minLength: 40)
            }
            .padding(.horizontal, 24)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .dark
                    ? [WindburnColors.darkBackground, .black]
                    : [.white, .gray.opacity(0.1)]
                ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }

    func signUpTapped() {
        var finalRole = selectedRole

        if selectedRole == "coach" {
            if rolePassword == adminKey {
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

        authViewModel.profileImageName = selectedProfileImage
        authViewModel.signUp(email: email, password: password, name: name, role: finalRole)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            authViewModel.updateProfileImage(name: selectedProfileImage)
        }
    }
}
