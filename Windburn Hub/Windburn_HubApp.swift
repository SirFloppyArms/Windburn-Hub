//
//  Windburn_HubApp.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-27.
//

import SwiftUI
import Firebase

@main
struct Windburn_HubApp: App {
    @StateObject var authViewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
