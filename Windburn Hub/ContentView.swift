//
//  ContentView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-27.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            if authViewModel.user != nil {
                VStack {
                    Text("Welcome, \(authViewModel.role.capitalized)")
                    Button("Log Out") {
                        authViewModel.logOut()
                    }
                }
            } else {
                LoginView()
            }
        }
    }
}
