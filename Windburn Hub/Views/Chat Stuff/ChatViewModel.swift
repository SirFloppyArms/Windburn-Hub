//
//  ChatViewModel.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import Foundation
import Firebase
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var newMessageText = ""

    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    let currentUserID: String
    let currentUserName: String
    let chatID: String
    let chatTitle: String

    init(currentUserID: String, currentUserName: String, chatID: String = "groupChat", chatTitle: String = "Team Chat") {
        self.currentUserID = currentUserID
        self.currentUserName = currentUserName
        self.chatID = chatID
        self.chatTitle = chatTitle
        fetchMessages()
    }

    func fetchMessages() {
        listener = db.collection("chats")
            .document(chatID)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.messages = documents.compactMap { doc in
                    try? doc.data(as: Message.self)
                }
            }
    }

    func sendMessage() {
        guard !newMessageText.isEmpty else { return }

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

    deinit {
        listener?.remove()
    }
}
