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
    @Published var profileImageName: String = "default" // NEW

    private let db = Firestore.firestore()

    init() {
        self.user = Auth.auth().currentUser
        fetchUserData()
    }

    func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                self.role = document.data()?["role"] as? String ?? ""
                self.displayName = document.data()?["name"] as? String ?? ""
                self.profileImageName = document.data()?["profileImage"] as? String ?? "default"
            }
        }
    }

    func updateDisplayName(to name: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).updateData(["name": name]) { error in
            if let error = error {
                print("Error updating name: \(error.localizedDescription)")
            } else {
                self.displayName = name
                self.fetchUserData() // ✅ Force refresh after update
            }
        }
    }

    func updateProfileImage(name: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(uid).updateData(["profileImage": name]) { error in
            if let error = error {
                print("Error updating profile image: \(error.localizedDescription)")
            } else {
                self.profileImageName = name
            }
        }
    }

    func sendPasswordReset() {
        guard let email = user?.email else { return }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Password reset error: \(error.localizedDescription)")
            } else {
                print("Password reset email sent.")
            }
        }
    }

    func signUp(email: String, password: String, name: String, role: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
                return
            }

            guard let uid = result?.user.uid else { return }

            self.db.collection("users").document(uid).setData([
                "email": email,
                "name": name,
                "role": role,
                "profileImage": "default", // NEW
                "dateJoined": Timestamp()
            ]) { error in
                if let error = error {
                    print("Error saving user data: \(error.localizedDescription)")
                } else {
                    print("User registered and saved.")
                    self.fetchUserData()
                }
            }

            self.user = result?.user
        }
    }

    func logIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                return
            }

            self.user = result?.user
            self.fetchUserData()
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.role = ""
            self.displayName = ""
            self.profileImageName = "default"
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
