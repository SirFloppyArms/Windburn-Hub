//
//  PerformanceListView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct PerformanceListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var performances: [Performance] = []
    @State private var isLoading = true
    @State private var showingLogForm = false

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else {
                    ScrollView {
                        if performances.isEmpty {
                            Text("No performances logged yet.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("🏅 Personal Bests")
                                    .font(.headline)
                                    .padding(.bottom, 4)

                                ForEach(personalBests(), id: \.self) { best in
                                    HStack {
                                        Text("\(best.label):")
                                        Spacer()
                                        Text(formatTime(seconds: best.time))
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.vertical, 2)
                                }

                                Divider().padding(.vertical)

                                Text("📘 All Logged Performances")
                                    .font(.headline)
                                    .padding(.bottom, 4)

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
                                    .padding(.vertical, 6)
                                    .padding(.horizontal)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                }
                            }
                            .padding()
                        }
                    }
                }

                Button(action: {
                    showingLogForm = true
                }) {
                    Label("Log Performance", systemImage: "plus")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding()
                }
                .sheet(isPresented: $showingLogForm) {
                    AddPerformanceView()
                }
            }
            .navigationTitle("My Stats")
            .onAppear {
                loadData()
            }
        }
    }

    func loadData() {
        guard let uid = authViewModel.user?.uid else { return }

        FirestoreService.shared.fetchPerformances(for: uid) { results in
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

    struct BestPerformance: Hashable {
        let label: String
        let time: Int
    }

    func personalBests() -> [BestPerformance] {
        var bests: [String: Int] = [:]

        for perf in performances {
            let key = "\(perf.sport)_\(perf.distance)"
            if let currentBest = bests[key] {
                if perf.time < currentBest {
                    bests[key] = perf.time
                }
            } else {
                bests[key] = perf.time
            }
        }

        return bests.map { key, time in
            BestPerformance(label: readableLabel(from: key), time: time)
        }
        .sorted(by: { $0.label < $1.label })
    }

    func readableLabel(from key: String) -> String {
        let parts = key.split(separator: "_")
        guard parts.count == 2 else { return key }
        let sport = parts[0].capitalized
        let dist = parts[1]
        return "\(sport) - \(dist) km"
    }
}
