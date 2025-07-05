//
//  PerformanceListView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct PerformanceListView: View {
    @ObservedObject var vm: StatsViewModel

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading performances...")
            } else if vm.myLogs.isEmpty {
                ContentUnavailableView("No Performance Logs", systemImage: "chart.bar.fill", description: Text("Start logging your stats!"))
            } else {
                List {
                    ForEach(vm.myLogs) { log in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(log.activity)
                                .font(.headline)
                            Text(log.result)
                            Text(log.date, style: .date)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationTitle("My Stats")
        .refreshable {
            vm.fetchLogs()
        }
    }
}
