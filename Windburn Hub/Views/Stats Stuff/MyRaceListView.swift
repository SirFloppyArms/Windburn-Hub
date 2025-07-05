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
    @State private var editingLog: RaceLog? = nil

    var body: some View {
        NavigationStack {
            VStack {
                if vm.isLoading {
                    ProgressView("Loading races...")
                } else if vm.myLogs.isEmpty {
                    ContentUnavailableView("No Races", systemImage: "flag.slash", description: Text("Tap below to log your first race!"))
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(vm.myLogs) { log in
                                RaceCardView(log: log, canEdit: vm.canEdit(log: log)) {
                                    editingLog = log
                                } onDelete: {
                                    vm.delete(log: log)
                                }
                            }
                        }
                        .padding(.top)
                    }
                }

                WindburnButton(title: "Add Race") {
                    showAddLog = true
                }
                .padding()
            }
            .navigationTitle("My Races")
            .sheet(isPresented: $showAddLog) {
                AddRaceView(viewModel: vm, authVM: vm.authVM)
            }
            .sheet(item: $editingLog) { log in
                EditRaceView(viewModel: vm, log: log)
            }
            .refreshable {
                vm.fetchLogs()
            }
        }
    }
}
