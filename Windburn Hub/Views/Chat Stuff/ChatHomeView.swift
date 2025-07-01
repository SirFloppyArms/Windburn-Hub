//
//  ChatHomeView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct ChatHomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = ChatHomeViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .dark
                    ? [WindburnColors.darkBackground, .black]
                    : [.white, .gray.opacity(0.05)]
                ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("Messages")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(WindburnColors.primary)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                if viewModel.chatSummaries.isEmpty {
                    VStack {
                        Spacer()
                        Text("No messages yet.")
                            .foregroundColor(.gray)
                            .font(.system(size: 16, weight: .medium))
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.chatSummaries) { chat in
                                NavigationLink(destination: ChatRoomRouter(chat: chat)) {
                                    ChatCard(chat: chat)
                                        .padding(.horizontal, 16)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
            }

            // Floating new chat button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: UserSearchView()) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(WindburnColors.secondary)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                            .padding()
                    }
                }
            }
        }
        .onAppear {
            if let userID = authViewModel.user?.uid {
                viewModel.loadChats(for: userID)
            }
        }
    }
}

struct ChatCard: View {
    let chat: ChatSummary
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                if chat.isGroup {
                    Circle()
                        .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
                        .frame(width: 48, height: 48)

                    Image("windburn")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .padding(4)
                } else {
                    Image(chat.profileImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(WindburnColors.secondary, lineWidth: 2))
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(chat.title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)

                Text(chat.lastMessage)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

struct ChatRoomRouter: View {
    let chat: ChatSummary
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        if let user = authViewModel.user {
            if !authViewModel.displayName.isEmpty {
                let viewModel = ChatViewModel(
                    currentUserID: user.uid,
                    currentUserName: authViewModel.displayName,
                    chatID: chat.id,
                    chatTitle: chat.title
                )
                ChatRoomView(chatViewModel: viewModel)
            } else {
                ProgressView("Loading...")
            }
        } else {
            Text("Not signed in.")
        }
    }
}
