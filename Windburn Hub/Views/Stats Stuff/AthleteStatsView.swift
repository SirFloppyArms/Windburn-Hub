//
//  AthleteStatsView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct AthleteStatsView: View {
    @ObservedObject var vm: StatsViewModel
    @State private var selectedUserId: String?
    @State private var selectedUserName: String = ""
    @State private var showAddLog = false

    var users: [String: String] {
        Dictionary(grouping: vm.allLogs, by: { $0.userId })
            .mapValues { $0.first?.userName ?? "Unknown" }
    }

    var filteredLogs: [PerformanceLog] {
        guard let userId = selectedUserId else { return [] }
        return vm.visibleLogs(for: userId)
    }

    var body: some View {
        VStack {
            Picker("Select Athlete", selection: $selectedUserId) {
                Text("Select...").tag(nil as String?)
                ForEach(users.sorted(by: { $0.value < $1.value }), id: \.key) { (id, name) in
                    Text(name).tag(id as String?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            if let userId = selectedUserId {
                if !filteredLogs.isEmpty {
                    List {
                        ForEach(filteredLogs) { log in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(log.activity)
                                    .font(.headline)
                                Text(log.result)
                                Text(log.date, style: .date)
                                    .foregroundColor(.gray)

                                if vm.canEdit(log: log) {
                                    NavigationLink("Edit Log") {
                                        EditPerformanceView(viewModel: vm, log: log)
                                    }
                                    .padding(.top, 4)
                                }
                            }
                            .padding(.vertical, 4)
                            .swipeActions(edge: .trailing) {
                                if vm.canDelete(log: log) {
                                    Button(role: .destructive) {
                                        vm.delete(log: log)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ContentUnavailableView("No Visible Logs", systemImage: "eye.slash", description: Text("This user has no public or accessible stats."))
                }

                // Add Log Button (only if viewing own logs or if coach/admin)
                if userId == vm.authVM.user?.uid || vm.authVM.role == "coach" || vm.authVM.role == "admin" {
                    Button {
                        showAddLog = true
                    } label: {
                        Label("Add Log", systemImage: "plus.circle")
                            .font(.headline)
                            .padding(.top)
                    }
                }
            } else {
                ContentUnavailableView("No Athlete Selected", systemImage: "person.crop.circle.badge.questionmark", description: Text("Select a user to view their stats."))
            }
        }
        .navigationTitle("Team Stats")
        .refreshable {
            vm.fetchLogs()
        }
        .sheet(isPresented: $showAddLog) {
            AddPerformanceView(viewModel: vm, authVM: vm.authVM)
        }
    }
}
