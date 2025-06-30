//
//  ChatSummary.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import Foundation

struct ChatSummary: Identifiable, Hashable {
    let id: String
    let title: String
    let lastMessage: String
    let isGroup: Bool
    let targetUserID: String?
}
