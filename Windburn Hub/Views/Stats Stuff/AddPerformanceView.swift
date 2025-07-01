//
//  AddPerformanceView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct AddPerformanceView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var sport = "Triathlon"
    @State private var eventType = "Race"
    @State private var distance = ""
    @State private var time = ""
    @State private var location = ""
    @State private var date = Date()
    @State private var notes = ""

    let sports = ["Triathlon", "Run", "Bike", "Swim"]
    let eventTypes = ["Race", "Training"]

    var body: some View {
        Form {
            Section(header: Text("Event Info")) {
                Picker("Sport", selection: $sport) {
                    ForEach(sports, id: \.self) { Text($0) }
                }

                Picker("Type", selection: $eventType) {
                    ForEach(eventTypes, id: \.self) { Text($0) }
                }

                TextField("Distance (km)", text: $distance)
                    .keyboardType(.decimalPad)

                TextField("Time (sec)", text: $time)
                    .keyboardType(.numberPad)

                TextField("Location", text: $location)

                DatePicker("Date", selection: $date, displayedComponents: .date)
            }

            Section(header: Text("Notes")) {
                TextField("How did it go?", text: $notes)
            }

            Button("Save") {
                savePerformance()
            }
        }
        .navigationTitle("Log Performance")
    }

    func savePerformance() {
        guard let uid = authViewModel.user?.uid,
              let dist = Double(distance),
              let secs = Int(time) else {
            return
        }

        let newPerformance = Performance(
            userID: uid,
            athleteName: authViewModel.displayName,
            eventType: eventType,
            sport: sport,
            distance: dist,
            time: secs,
            location: location,
            date: date,
            notes: notes,
            createdAt: Date()
        )

        FirestoreService.shared.addPerformance(newPerformance) { error in
            if let error = error {
                print("Error saving performance: \(error.localizedDescription)")
            } else {
                print("Performance saved!")
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
