//
//  EventDetailView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct EventDetailView: View {
    var event: Event
    var isEditable: Bool
    var onEdit: () -> Void
    var onDelete: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(event.title)
                    .font(.largeTitle)
                    .bold()

                Text(event.date.formatted(date: .long, time: .shortened))
                    .foregroundColor(.secondary)

                Text("📍 Location: \(event.location)")
                if !event.registrationLink.isEmpty {
                    Link("📝 Register", destination: URL(string: event.registrationLink)!)
                }
                if !event.courseMapURL.isEmpty {
                    Link("🗺 View Course Map", destination: URL(string: event.courseMapURL)!)
                }

                Divider()

                Text(event.details)
                    .padding(.top)

                if isEditable {
                    HStack {
                        Button("Edit", action: onEdit)
                            .buttonStyle(.borderedProminent)

                        Button("Delete", role: .destructive, action: onDelete)
                            .buttonStyle(.bordered)
                    }
                    .padding(.top)
                }
            }
            .padding()
        }
    }
}
