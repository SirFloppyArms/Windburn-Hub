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
    @State private var searchText: String = ""

    var filteredUsers: [AppUser] {
        if searchText.isEmpty {
            return viewModel.users
        } else {
            return viewModel.users.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(WindburnColors.primary)
                    TextField("Search users...", text: $searchText)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.primary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(WindburnColors.primary.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal)

                // User List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredUsers) { user in
                            Button {
                                startPrivateChat(with: user)
                            } label: {
                                HStack(spacing: 16) {
                                    Circle()
                                        .fill(WindburnColors.secondary)
                                        .frame(width: 48, height: 48)
                                        .overlay(
                                            Text(user.name.prefix(1))
                                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                                .foregroundColor(.white)
                                        )

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(user.name)
                                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                                            .foregroundColor(.primary)
                                        Text(user.role.capitalized)
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundColor(WindburnColors.primary)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(.ultraThinMaterial)
                                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(WindburnColors.primary.opacity(0.2), lineWidth: 1)
                                        )
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Start a Chat")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [WindburnColors.darkBackground, WindburnColors.cardDark]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .onAppear {
                if let currentUserID = authViewModel.user?.uid {
                    viewModel.fetchUsers(excluding: currentUserID)
                }
            }
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
                targetUserID: targetUID,
                profileImageName: user.profileImageName
            )
        }
    }
}
