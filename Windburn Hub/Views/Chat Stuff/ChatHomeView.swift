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

    var body: some View {
        List(viewModel.chatSummaries) { chat in
            NavigationLink(destination: ChatRoomRouter(chat: chat)) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(chat.title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(chat.lastMessage)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .padding(.vertical, 6)
            }
        }
        .navigationTitle("Messages")
        .toolbar {
            NavigationLink(destination: UserSearchView()) {
                Image(systemName: "square.and.pencil")
            }
        }
        .onAppear {
            if let userID = authViewModel.user?.uid {
                viewModel.loadChats(for: userID)
            }
        }
    }
}

struct ChatRoomRouter: View {
    let chat: ChatSummary
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        if let user = authViewModel.user {
            let viewModel = ChatViewModel(
                currentUserID: user.uid,
                currentUserName: authViewModel.displayName,
                chatID: chat.id,
                chatTitle: chat.title
            )
            ChatRoomView(chatViewModel: viewModel)
        } else {
            Text("Not signed in.")
        }
    }
}
