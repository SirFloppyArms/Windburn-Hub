//
//  ProfileView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingImagePicker = false

    // Set of predefined image names you’ve uploaded to your asset catalog
    let availableImages = ["default", "bike1", "run1", "swim1", "windburn"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    HStack {
                        Image(authViewModel.profileImageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))

                        VStack(alignment: .leading) {
                            Text(authViewModel.displayName)
                                .font(.headline)
                            Text(authViewModel.user?.email ?? "Unknown Email")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(authViewModel.role.capitalized)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Section(header: Text("Edit Profile")) {
                    NavigationLink("Change Display Name") {
                        ChangeNameView()
                    }

                    NavigationLink("Change Profile Picture") {
                        ProfileImagePickerView()
                    }

                    Button("Send Password Reset Email") {
                        authViewModel.sendPasswordReset()
                    }
                }

                Section {
                    Button(action: {
                        authViewModel.logOut()
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}
