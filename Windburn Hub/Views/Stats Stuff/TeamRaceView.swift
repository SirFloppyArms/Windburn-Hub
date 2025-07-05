//
//  TeamRaceView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-07-04.
//

import SwiftUI

struct TeamRaceView: View {
    @ObservedObject var vm: StatsViewModel
    @State private var selectedUserId: String? = nil
    @State private var editingLog: RaceLog? = nil

    var users: [String: String] {
        Dictionary(grouping: vm.allLogs, by: { $0.userId })
            .mapValues { $0.first?.userName ?? "Unknown" }
    }

    var filteredLogs: [RaceLog] {
        guard let userId = selectedUserId else { return [] }
        return vm.visibleLogs(for: userId)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Select Athlete", selection: $selectedUserId) {
                    Text("Select...").tag(nil as String?)
                    ForEach(users.sorted(by: { $0.value < $1.value }), id: \ .key) { (id, name) in
                        Text(name).tag(id as String?)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)

                if let _ = selectedUserId, !filteredLogs.isEmpty {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredLogs) { log in
                                RaceCardView(log: log, canEdit: vm.canEdit(log: log)) {
                                    editingLog = log
                                } onDelete: {
                                    vm.delete(log: log)
                                }
                            }
                        }
                        .padding(.top)
                    }
                } else if selectedUserId != nil {
                    ContentUnavailableView("No Public Races", systemImage: "eye.slash", description: Text("This user has no public race logs."))
                        .padding()
                } else {
                    ContentUnavailableView("No Athlete Selected", systemImage: "person.crop.circle.badge.questionmark", description: Text("Select an athlete to view their race logs."))
                        .padding()
                }
            }
            .navigationTitle("Team Races")
            .sheet(item: $editingLog) { log in
                EditRaceView(viewModel: vm, log: log)
            }
            .refreshable {
                vm.fetchLogs()
            }
        }
    }
}
