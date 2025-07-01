//
//  ChatViewModel.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var newMessageText = ""

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    let currentUserID: String
    @Published var currentUserName: String
    let chatID: String
    let chatTitle: String

    init(currentUserID: String, currentUserName: String, chatID: String = "groupChat", chatTitle: String = "Team Chat") {
        self.currentUserID = currentUserID
        self.currentUserName = currentUserName
        self.chatID = chatID
        self.chatTitle = chatTitle
        fetchMessages()
    }

    func sendMessage() {
        guard !newMessageText.isEmpty else { return }

        guard !currentUserName.isEmpty else {
            print("🛑 Cannot send message: display name is empty")
            return
        }

        let message = Message(
            text: newMessageText,
            senderID: currentUserID,
            senderName: currentUserName,
            timestamp: Date()
        )

        do {
            _ = try db.collection("chats")
                .document(chatID)
                .collection("messages")
                .addDocument(from: message)

            newMessageText = ""
        } catch {
            print("Failed to send message: \(error)")
        }
    }

    func fetchMessages() {
        listener = db.collection("chats")
            .document(chatID)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.messages = documents.compactMap { doc in
                    do {
                        return try doc.data(as: Message.self)
                    } catch {
                        print("🧨 Message decode failed: \(error.localizedDescription)")
                        return nil
                    }
                }
            }
    }

    deinit {
        listener?.remove()
    }
}
