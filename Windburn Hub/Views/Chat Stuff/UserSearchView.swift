//
//  UserSearchView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI
import Firebase

struct UserSearchView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = UserListViewModel()

    @State private var selectedChatSummary: ChatSummary? = nil

    var body: some View {
        NavigationStack {
            List(viewModel.users) { user in
                Button {
                    startPrivateChat(with: user)
                } label: {
                    VStack(alignment: .leading) {
                        Text(user.name).bold()
                        Text(user.role.capitalized)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Start a Chat")
            .onAppear {
                if let currentUserID = authViewModel.user?.uid {
                    viewModel.fetchUsers(excluding: currentUserID)
                }
            }
            // ✅ Clean navigation link using optional ChatSummary
            .navigationDestination(item: $selectedChatSummary) { chat in
                ChatRoomRouter(chat: chat)
            }
        }
    }

    func startPrivateChat(with user: AppUser) {
        guard
            let currentUID = authViewModel.user?.uid,
            let targetUID = user.id,
            !targetUID.isEmpty
        else {
            print("❌ Invalid user or missing UID")
            return
        }

        let chatID = ChatIDHelper.privateChatID(for: currentUID, and: targetUID)

        // 🟢 Add to chatsIndex if not already there
        let db = Firestore.firestore()
        let indexRef = db.collection("chatsIndex").document(chatID)

        indexRef.getDocument { snapshot, error in
            if snapshot?.exists != true {
                indexRef.setData([
                    "participants": [currentUID, targetUID],
                    "lastMessage": "",
                    "lastUpdated": FieldValue.serverTimestamp()
                ])
            }

            selectedChatSummary = ChatSummary(
                id: chatID,
                title: user.name,
                lastMessage: "",
                isGroup: false,
                targetUserID: targetUID
            )
        }
    }
}
