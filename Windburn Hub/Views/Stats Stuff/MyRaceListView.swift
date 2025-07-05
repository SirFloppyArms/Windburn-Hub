//
//  MyRaceListView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-07-04.
//

import SwiftUI

struct MyRaceListView: View {
    @ObservedObject var vm: StatsViewModel
    @State private var showAddLog = false

    var body: some View {
        VStack {
            if vm.isLoading {
                ProgressView("Loading races...")
            } else if vm.myLogs.isEmpty {
                ContentUnavailableView("No Races", systemImage: "flag.slash", description: Text("Tap below to log your first race!"))
            } else {
                List {
                    ForEach(vm.myLogs) { log in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(log.raceName).font(.headline)
                            Text(log.overallTime)
                            Text(log.raceDate, style: .date).foregroundColor(.gray)

                            NavigationLink("Edit") {
                                EditRaceView(viewModel: vm, log: log)
                            }
                        }
                        .padding(.vertical, 4)
                        .swipeActions(edge: .trailing) {
                            if vm.canEdit(log: log) {
                                Button(role: .destructive) {
                                    vm.delete(log: log)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }

            Button {
                showAddLog = true
            } label: {
                Label("Add Race", systemImage: "plus")
                    .font(.headline)
                    .padding()
            }
        }
        .navigationTitle("My Races")
        .refreshable {
            vm.fetchLogs()
        }
        .sheet(isPresented: $showAddLog) {
            AddRaceView(viewModel: vm, authVM: vm.authVM)
        }
    }
}
