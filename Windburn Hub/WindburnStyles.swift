//
//  WindburnStyles.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-07-01.
//

import SwiftUI

struct WindburnColors {
    static let primary = Color(hex: "#00D0FF")        // Sky Cyan
    static let secondary = Color(hex: "#0054D1")      // Deep Azure Blue
    static let accent = Color(hex: "#C8FF00")         // Lime-Yellow
    static let lightBackground = Color.white
    static let darkBackground = Color(hex: "#0D1117")
    static let cardDark = Color(hex: "#1A1A2E")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

struct WindburnTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(14)
        .font(.system(size: 16, weight: .medium, design: .rounded))
    }
}

struct WindburnButton: View {
    let title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(LinearGradient(colors: [WindburnColors.secondary, WindburnColors.primary], startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(24)
                .font(.system(size: 16, weight: .bold, design: .rounded))
        }
    }
}
