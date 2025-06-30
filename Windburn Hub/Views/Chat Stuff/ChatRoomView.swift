//
//  ChatRoomView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct ChatRoomView: View {
    @ObservedObject var chatViewModel: ChatViewModel

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(Array(chatViewModel.messages.enumerated()), id: \.1.id) { index, message in
                        let isCurrentUser = message.senderID == chatViewModel.currentUserID
                        let showName = shouldShowName(for: index, messages: chatViewModel.messages)

                        VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 2) {
                            if showName && !isCurrentUser {
                                Text(message.senderName)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 12)
                            }

                            HStack {
                                if isCurrentUser { Spacer() }

                                Text(message.text)
                                    .padding(10)
                                    .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(isCurrentUser ? .white : .black)
                                    .cornerRadius(12)
                                    .frame(maxWidth: 250, alignment: isCurrentUser ? .trailing : .leading)

                                if !isCurrentUser { Spacer() }
                            }
                            .padding(.horizontal, 10)
                        }
                        .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
                    }
                }
                .padding(.top, 10)
            }

            HStack {
                TextField("Type a message...", text: $chatViewModel.newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    chatViewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .navigationTitle(chatViewModel.chatTitle)
    }

    func shouldShowName(for index: Int, messages: [Message]) -> Bool {
        if index == 0 { return true }
        let current = messages[index]
        let previous = messages[index - 1]
        return current.senderID != previous.senderID
    }
}
