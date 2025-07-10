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
                // Race Info
                Section(header: Text("Race Info")) {
                    Text(race.raceName)
                    Text(race.raceDate.formatted(date: .long, time: .omitted))
                    Text(race.location)
                    Text("Category: \(race.category)")
                    Text("Race Type: \(race.raceType.displayName)")
                }
                
                // Dynamic Split Times
                Section(header: Text("Split Times")) {
                    switch race.raceType ?? .triathlon {
                    case .triathlon:
                        Text("Swim: \(race.swimTime)")
                        Text("T1: \(race.t1Time)")
                        Text("Bike: \(race.bikeTime)")
                        Text("T2: \(race.t2Time)")
                        Text("Run: \(race.runTime)")

                    case .duathlon:
                        Text("Run 1: \(race.swimTime)") // reuse swimTime for Run 1
                        Text("T1: \(race.t1Time)")
                        Text("Bike: \(race.bikeTime)")
                        Text("T2: \(race.t2Time)")
                        Text("Run 2: \(race.runTime)")

                    case .aquabike:
                        Text("Swim: \(race.swimTime)")
                        Text("T1: \(race.t1Time)")
                        Text("Bike: \(race.bikeTime)")

                    case .cyclingRace:
                        Text("Bike: \(race.bikeTime)")

                    case .runningRace:
                        Text("Run: \(race.runTime)")

                    case .swim:
                        Text("Swim: \(race.swimTime)")

                    case .other:
                        Text("Finish Time: \(race.overallTime)")
                    }

                    // Always show overall
                    Text("Overall: \(race.overallTime)")
                        .bold()
                }

                // Notes
                if !race.notes.isEmpty {
                    Section(header: Text("Notes")) {
                        Text(race.notes)
                    }
                }

                // Visibility
                Section {
                    Label(race.isPublic ? "Visible to others" : "Private", systemImage: race.isPublic ? "eye" : "eye.slash")
                        .foregroundColor(race.isPublic ? .green : .red)
                }
            }
            .navigationTitle("Race Details")
        }
    }
}
