//
//  ChatRoomView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct ChatRoomView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            chatScrollView
            Divider().background(Color.gray.opacity(0.2))
            messageInputBar
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(
                    colorScheme == .dark ? WindburnColors.cardDark : Color(.systemBackground)
                )
        }
        .navigationTitle(chatViewModel.chatTitle)
        .navigationBarTitleDisplayMode(.inline)
        .background(
            colorScheme == .dark
                ? WindburnColors.darkBackground.ignoresSafeArea()
                : WindburnColors.lightBackground.ignoresSafeArea()
        )
    }

    // MARK: - Scrollable Message List
    private var chatScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(Array(chatViewModel.messages.enumerated()), id: \.1.id) { index, message in
                        messageBubble(for: message, at: index)
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 80)
            }
            .onChange(of: chatViewModel.messages.count) { _ in
                if let lastID = chatViewModel.messages.last?.id {
                    withAnimation {
                        proxy.scrollTo(lastID, anchor: .bottom)
                    }
                }
            }
        }
    }

    // MARK: - Message Bubble
    @ViewBuilder
    private func messageBubble(for message: Message, at index: Int) -> some View {
        let isCurrentUser = message.senderID == chatViewModel.currentUserID
        let showName = shouldShowName(for: index, messages: chatViewModel.messages)

        VStack(alignment: .leading, spacing: 2) {
            if showName && !isCurrentUser {
                Text(message.senderName)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading, 12)
            }

            HStack {
                if !isCurrentUser {
                    // Align left bubble
                    Text(message.text)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(colorScheme == .dark ? WindburnColors.cardDark : Color(.systemGray6))
                        .foregroundColor(.primary)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                        .padding(.leading, 12)
                        .padding(.trailing, 40)
                    Spacer(minLength: 0)
                } else {
                    Spacer(minLength: 0)
                    // Align right bubble
                    Text(message.text)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(WindburnColors.primary)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                        .padding(.trailing, 12)
                        .padding(.leading, 40)
                }
            }
        }
        .padding(.vertical, 4)
        .id(message.id)
    }

    // MARK: - Input Bar
    private var messageInputBar: some View {
        HStack(spacing: 10) {
            TextField("Type a message...", text: $chatViewModel.newMessageText, axis: .vertical)
                .padding(12)
                .background(colorScheme == .dark ? Color.white.opacity(0.05) : Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .font(.system(size: 16))
                .lineLimit(1...4)

            Button(action: chatViewModel.sendMessage) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(WindburnColors.secondary)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
            }
        }
    }

    // MARK: - Name Logic
    private func shouldShowName(for index: Int, messages: [Message]) -> Bool {
        guard index > 0 else { return true }
        return messages[index].senderID != messages[index - 1].senderID
    }
}
