//
//  LoginView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-27.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 40)

            Image("windburn")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)

            Text("Log In")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(WindburnColors.primary)

            WindburnTextField(placeholder: "Email", text: $email)
            WindburnTextField(placeholder: "Password", text: $password, isSecure: true)

            WindburnButton(title: "Log In") {
                authViewModel.logIn(email: email, password: password)
            }

            NavigationLink("Don't have an account? Sign Up", destination: SignUpView())
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(WindburnColors.secondary)

            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
}
