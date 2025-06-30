//
//  ChatIDHelper.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import Foundation

struct ChatIDHelper {
    static func privateChatID(for user1: String, and user2: String) -> String {
        let sorted = [user1, user2].sorted()
        return "private_\(sorted[0])_\(sorted[1])"
    }
}
