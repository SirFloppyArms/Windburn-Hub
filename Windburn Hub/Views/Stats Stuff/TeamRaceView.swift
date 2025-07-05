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

    var users: [String: String] {
        Dictionary(grouping: vm.allLogs, by: { $0.userId })
            .mapValues { $0.first?.userName ?? "Unknown" }
    }

    var filteredLogs: [RaceLog] {
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

            if let userId = selectedUserId, !filteredLogs.isEmpty {
                List {
                    ForEach(filteredLogs) { log in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(log.raceName).font(.headline)
                            Text(log.overallTime)
                            Text(log.raceDate, style: .date).foregroundColor(.gray)

                            if vm.canEdit(log: log) {
                                NavigationLink("Edit") {
                                    EditRaceView(viewModel: vm, log: log)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            } else if selectedUserId != nil {
                ContentUnavailableView("No Public Races", systemImage: "eye.slash", description: Text("This user has no public race logs."))
            } else {
                ContentUnavailableView("No Athlete Selected", systemImage: "person.crop.circle.badge.questionmark", description: Text("Select an athlete to view their race logs."))
            }
        }
        .navigationTitle("Team Races")
        .refreshable {
            vm.fetchLogs()
        }
    }
}
