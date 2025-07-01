//
//  ChatHomeviewModel.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import Foundation
import Firebase

class ChatHomeViewModel: ObservableObject {
    @Published var chatSummaries: [ChatSummary] = []
    private let db = Firestore.firestore()

    func loadChats(for userID: String) {
        var summaries: [ChatSummary] = []
        let dispatch = DispatchGroup()

        // ✅ Always load the team chat
        dispatch.enter()
        db.collection("chats").document("groupChat").collection("messages")
            .order(by: "timestamp", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, _ in
                let lastText = snapshot?.documents.first?["text"] as? String ?? "No messages yet"
                summaries.append(ChatSummary(
                    id: "groupChat",
                    title: "Team Chat",
                    lastMessage: lastText,
                    isGroup: true,
                    targetUserID: nil,
                    profileImageName: "default"
                ))
                dispatch.leave()
            }

        // ✅ Load private chats from chatsIndex
        dispatch.enter()
        db.collection("chatsIndex")
            .whereField("participants", arrayContains: userID)
            .getDocuments { snapshot, _ in
                let docs = snapshot?.documents ?? []

                for doc in docs {
                    let chatID = doc.documentID
                    let participants = doc["participants"] as? [String] ?? []
                    guard participants.count == 2 else { continue }

                    guard let otherID = participants.first(where: { $0 != userID }), !otherID.isEmpty else {
                        continue
                    }

                    dispatch.enter()

                    self.db.collection("chats").document(chatID).collection("messages")
                        .order(by: "timestamp", descending: true)
                        .limit(to: 1)
                        .getDocuments { msgSnap, _ in
                            let lastText = msgSnap?.documents.first?["text"] as? String ?? "No messages yet"

                            self.db.collection("users").document(otherID).getDocument { userDoc, _ in
                                let name = userDoc?.data()?["name"] as? String ?? "Unknown"
                                let profileImage = userDoc?.data()?["profileImage"] as? String ?? "default"

                                summaries.append(ChatSummary(
                                    id: chatID,
                                    title: name,
                                    lastMessage: lastText,
                                    isGroup: false,
                                    targetUserID: otherID,
                                    profileImageName: profileImage // 👈 Include this!
                                ))

                                dispatch.leave()
                            }
                        }
                }

                dispatch.leave()
            }

        dispatch.notify(queue: .main) {
            self.chatSummaries = summaries.sorted { lhs, rhs in
                if lhs.isGroup { return true }
                if rhs.isGroup { return false }
                return lhs.title.localizedCompare(rhs.title) == .orderedAscending
            }
        }
    }
}
