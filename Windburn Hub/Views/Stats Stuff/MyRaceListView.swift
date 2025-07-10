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
    @State private var selectedLog: RaceLog? = nil

    var body: some View {
        NavigationStack {
            VStack {
                if vm.isLoading {
                    ProgressView("Loading races...")
                } else if vm.myLogs.isEmpty {
                    ContentUnavailableView("No Races", systemImage: "flag.slash", description: Text("Tap below to log your first race!"))
                } else {
                    Picker("Filter by Race Type", selection: $vm.selectedRaceType) {
                        Text("All").tag(nil as RaceType?)
                        ForEach(RaceType.allCases) { type in
                            Text(type.displayName).tag(type as RaceType?)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(vm.filteredMyLogs) { log in
                                RaceCardView(log: log, canEdit: vm.canEdit(log: log)) {
                                    editingLog = log
                                } onDelete: {
                                    vm.delete(log: log)
                                } onTap: {
                                    selectedLog = log
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
            .sheet(item: $selectedLog) { log in
                RaceDetailView(race: log)
            }
            .refreshable {
                vm.fetchLogs()
            }
        }
    }
}
