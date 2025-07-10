//
//  RaceCardView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-07-04.
//

import SwiftUI

struct RaceCardView: View {
    let log: RaceLog
    let canEdit: Bool
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onTap: () -> Void  // ✅ NEW

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(log.raceName)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text("Overall Time: \(log.overallTime)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(log.raceDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                if canEdit {
                    Menu {
                        Button("Edit", systemImage: "pencil", action: onEdit)
                        Button("Delete", role: .destructive, action: onDelete)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal)
        .onTapGesture {
            onTap() // ✅ Open detail when tapped
        }
    }
}
