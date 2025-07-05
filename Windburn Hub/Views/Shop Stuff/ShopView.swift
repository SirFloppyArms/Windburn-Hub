//
//  HomeView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI
import WebKit

struct ShopView: View {
    @State private var isLoading = true
    private let url = URL(string: "https://worldtriathlonstore.ca/collections/windburn")!

    var body: some View {
        ZStack {
            WebView(url: url, isLoading: $isLoading)

            if isLoading {
                ProgressView("Loading store...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .background(Color(.systemBackground).opacity(0.8))
                    .cornerRadius(12)
                    .shadow(radius: 4)
            }
        }
        .navigationTitle("Team Store")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground).ignoresSafeArea())
    }
}
