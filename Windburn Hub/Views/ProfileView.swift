//
//  ProfileView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)

                        VStack(alignment: .leading) {
                            Text(authViewModel.user?.email ?? "Unknown Email")
                                .font(.headline)
                            Text(authViewModel.role.capitalized)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }

                Section(header: Text("Settings")) {
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
