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
                    Text("Race Type: \(race.raceType.displayName)")
                }

                splitTimesSection(for: race)

                if !race.notes.isEmpty {
                    Section(header: Text("Notes")) {
                        Text(race.notes)
                    }
                }

                Section {
                    Label(
                        race.isPublic ? "Visible to others" : "Private",
                        systemImage: race.isPublic ? "eye" : "eye.slash"
                    )
                    .foregroundColor(race.isPublic ? .green : .red)
                }
            }
            .navigationTitle("Race Details")
        }
    }

    // MARK: - Dynamic Split Times Section
    @ViewBuilder
    private func splitTimesSection(for race: RaceLog) -> some View {
        Section(header: Text("Split Times")) {
            switch race.raceType ?? .triathlon {
            case .triathlon:
                Text("Swim: \(race.swimTime)")
                Text("T1: \(race.t1Time)")
                Text("Bike: \(race.bikeTime)")
                Text("T2: \(race.t2Time)")
                Text("Run: \(race.runTime)")

            case .duathlon:
                Text("Run 1: \(race.swimTime)")
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
                if let segments = race.customSegments, !segments.isEmpty {
                    ForEach(segments) { segment in
                        Text("\(segment.name): \(segment.time)")
                    }
                } else {
                    Text("Finish Time: \(race.overallTime)")
                }
            }

            // Always show overall
            Text("Overall: \(race.overallTime)")
                .bold()
        }
    }
}
