//
//  StatsView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct StatsView: View {
    var body: some View {
        TabView {
            PerformanceListView()
                .tabItem {
                    Label("My Stats", systemImage: "chart.bar.fill")
                }

            AthleteStatsView()
                .tabItem {
                    Label("Team", systemImage: "person.3.fill")
                }
        }
    }
}
