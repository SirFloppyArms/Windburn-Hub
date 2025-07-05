//
//  RaceDetailView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-07-04.
//

import SwiftUI

struct RaceDetailView: View {
    let race: RaceLog

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Race Info")) {
                    Text(race.raceName)
                    Text(race.raceDate.formatted(date: .long, time: .omitted))
                    Text(race.location)
                    Text("Category: \(race.category)")
                }

                Section(header: Text("Split Times")) {
                    Text("Swim: \(race.swimTime)")
                    Text("T1: \(race.t1Time)")
                    Text("Bike: \(race.bikeTime)")
                    Text("T2: \(race.t2Time)")
                    Text("Run: \(race.runTime)")
                    Text("Overall: \(race.overallTime)")
                        .bold()
                }

                if !race.notes.isEmpty {
                    Section(header: Text("Notes")) {
                        Text(race.notes)
                    }
                }

                Section {
                    Label(race.isPublic ? "Visible to others" : "Private", systemImage: race.isPublic ? "eye" : "eye.slash")
                        .foregroundColor(race.isPublic ? .green : .red)
                }
            }
            .navigationTitle("Race Details")
        }
    }
}
