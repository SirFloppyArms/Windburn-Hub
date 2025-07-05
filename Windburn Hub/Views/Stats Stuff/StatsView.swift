//
//  StatsView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct StatsView: View {
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var statsVM: StatsViewModel

    init() {
        let auth = AuthViewModel()
        _statsVM = StateObject(wrappedValue: StatsViewModel(authViewModel: auth))
    }

    var body: some View {
        TabView {
            NavigationStack {
                MyRaceListView(vm: statsVM)
            }
            .tabItem {
                Label("My Races", systemImage: "person.fill")
            }

            NavigationStack {
                TeamRaceView(vm: statsVM)
            }
            .tabItem {
                Label("Team", systemImage: "person.3.fill")
            }
        }
    }
}
