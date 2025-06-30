//
//  AuthViewModel.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-27.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var role: String = ""
    @Published var displayName: String = ""

    private let db = Firestore.firestore()

    init() {
        self.user = Auth.auth().currentUser
        fetchUserRole()
        fetchDisplayName()
    }

    func signUp(email: String, password: String, name: String, role: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
                return
            }

            guard let uid = result?.user.uid else { return }

            // Save user data in Firestore
            self.db.collection("users").document(uid).setData([
                "email": email,
                "name": name,
                "role": role,
                "dateJoined": Timestamp()
            ]) { error in
                if let error = error {
                    print("Error saving user data: \(error.localizedDescription)")
                } else {
                    print("User registered and saved.")
                    self.fetchUserRole()
                }
            }

            self.user = result?.user
            self.fetchDisplayName()
        }
    }

    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                return
            }

            self.user = result?.user
            self.fetchUserRole()
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.role = ""
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    func fetchUserRole() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                self.role = document.data()?["role"] as? String ?? ""
            }
        }
    }

    func fetchDisplayName() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                self.displayName = document.data()?["name"] as? String ?? ""
            }
        }
    }
}
