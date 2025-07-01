//
//  AthleteStatsView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI
import FirebaseFirestore

struct AthleteStatsView: View {
    @State private var users: [UserInfo] = []
    @State private var selectedUser: UserInfo? = nil
    @State private var performances: [Performance] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            VStack {
                if selectedUser == nil {
                    List(users) { user in
                        Button(action: {
                            selectedUser = user
                            loadPerformances(for: user)
                        }) {
                            HStack {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.blue)
                                Text(user.name)
                                    .font(.headline)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .navigationTitle("Athletes")
                } else {
                    VStack {
                        Text("\(selectedUser!.name)'s Performances")
                            .font(.title3)
                            .bold()
                            .padding(.top)

                        if isLoading {
                            ProgressView("Loading...")
                        } else if performances.isEmpty {
                            Text("No performances logged.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ScrollView {
                                ForEach(performances) { perf in
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(perf.sport)
                                                .font(.headline)
                                            Spacer()
                                            Text(perf.date, style: .date)
                                                .foregroundColor(.gray)
                                        }

                                        Text("\(perf.eventType) • \(String(format: "%.1f", perf.distance)) km")
                                            .font(.subheadline)

                                        Text("Time: \(formatTime(seconds: perf.time))")
                                            .font(.subheadline)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                    .padding(.bottom, 8)
                                }
                            }
                        }

                        Button("Back to Athletes") {
                            selectedUser = nil
                            performances = []
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                if users.isEmpty {
                    loadUsers()
                }
            }
        }
    }

    func loadUsers() {
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            self.users = docs.compactMap { doc in
                let data = doc.data()
                guard
                    let name = data["name"] as? String
                else { return nil }
                return UserInfo(id: doc.documentID, name: name)
            }
        }
    }

    func loadPerformances(for user: UserInfo) {
        isLoading = true
        FirestoreService.shared.fetchPerformances(for: user.id) { results in
            self.performances = results.sorted(by: { $0.date > $1.date })
            self.isLoading = false
        }
    }

    func formatTime(seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        return h > 0 ? "\(h)h \(m)m \(s)s" : "\(m)m \(s)s"
    }

    struct UserInfo: Identifiable, Hashable {
        var id: String
        var name: String
    }
}
