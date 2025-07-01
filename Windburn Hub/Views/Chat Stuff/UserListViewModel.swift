//
//  UserListViewModel.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import Foundation
import FirebaseFirestore

class UserListViewModel: ObservableObject {
    @Published var users: [AppUser] = []

    func fetchUsers(excluding uid: String) {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField(FieldPath.documentID(), isNotEqualTo: uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching users: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self.users = documents.compactMap { doc in
                    try? doc.data(as: AppUser.self)
                }

                print("✅ Fetched users: \(self.users.map { $0.name })")
            }
    }
}
