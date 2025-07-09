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
            VStack(alignment: .leading, spacing: 20) {
                // Card header
                VStack(alignment: .leading, spacing: 6) {
                    Text(event.title)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(WindburnColors.accent)

                    Text(event.date.formatted(date: .long, time: .shortened))
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("📍 \(event.location)")
                        .font(.body)
                        .foregroundColor(.white)
                }
                .padding()
                .background(WindburnColors.cardDark)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 2)

                // Links
                if !event.registrationLink.isEmpty || !event.courseMapURL.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        if !event.registrationLink.isEmpty {
                            Link(destination: URL(string: event.registrationLink)!) {
                                HStack {
                                    Image(systemName: "pencil.and.outline")
                                    Text("Register")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(WindburnColors.primary)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }

                        if !event.courseMapURL.isEmpty {
                            Link(destination: URL(string: event.courseMapURL)!) {
                                HStack {
                                    Image(systemName: "map")
                                    Text("View Course Map")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(WindburnColors.secondary)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }
                    }
                }

                // Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Details")
                        .font(.title3)
                        .bold()
                        .foregroundColor(WindburnColors.accent)

                    Text(event.details)
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                }
                .padding()
                .background(WindburnColors.cardDark)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 1)

                // Edit/Delete buttons
                if isEditable {
                    HStack {
                        WindburnButton(title: "Edit", action: onEdit)

                        Button(action: onDelete) {
                            Text("Delete")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(24)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .padding()
            .background(WindburnColors.darkBackground)
        }
    }
}
