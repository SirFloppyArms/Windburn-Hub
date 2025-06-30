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
    private let db = Firestore.firestore()

    func fetchUsers(excluding currentUserID: String) {
        db.collection("users").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }

            self.users = documents.compactMap { doc -> AppUser? in
                let result = try? doc.data(as: AppUser.self)
                return result?.id != currentUserID ? result : nil
            }
        }
    }
}
