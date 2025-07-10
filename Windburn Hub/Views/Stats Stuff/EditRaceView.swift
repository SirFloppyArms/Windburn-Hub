//
//  EditRaceView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-07-04.
//

import SwiftUI

struct EditRaceView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: StatsViewModel
    @State var log: RaceLog

    @State private var isSaving = false
    @State private var showError = false
    @State private var errorMessage = ""

    @State private var selectedRaceType: RaceType = .triathlon

    var body: some View {
        NavigationStack {
            Form {
                // Race Info
                Section(header: Text("Race Info")) {
                    TextField("Race Name", text: $log.raceName)
                    DatePicker("Race Date", selection: $log.raceDate, displayedComponents: .date)
                    TextField("Location", text: $log.location)
                    TextField("Category", text: $log.category)

                    Picker("Race Type", selection: $selectedRaceType) {
                        ForEach(RaceType.allCases) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                }

                // Dynamic Split Times
                Section(header: Text("Split Times")) {
                    switch selectedRaceType {
                    case .triathlon:
                        TextField("Swim Time", text: $log.swimTime)
                        TextField("T1 Time", text: $log.t1Time)
                        TextField("Bike Time", text: $log.bikeTime)
                        TextField("T2 Time", text: $log.t2Time)
                        TextField("Run Time", text: $log.runTime)

                    case .duathlon:
                        TextField("Run 1 Time", text: $log.swimTime) // reuse swimTime for run1
                        TextField("T1 Time", text: $log.t1Time)
                        TextField("Bike Time", text: $log.bikeTime)
                        TextField("T2 Time", text: $log.t2Time)
                        TextField("Run 2 Time", text: $log.runTime)

                    case .aquabike:
                        TextField("Swim Time", text: $log.swimTime)
                        TextField("T1 Time", text: $log.t1Time)
                        TextField("Bike Time", text: $log.bikeTime)

                    case .cyclingRace:
                        TextField("Bike Time", text: $log.bikeTime)

                    case .runningRace:
                        TextField("Run Time", text: $log.runTime)

                    case .swim:
                        TextField("Swim Time", text: $log.swimTime)

                    case .other:
                        TextField("Finish Time", text: $log.overallTime)
                    }

                    // Always allow overall time input
                    TextField("Overall Time", text: $log.overallTime)
                }

                // Notes
                Section(header: Text("Additional Notes")) {
                    TextEditor(text: $log.notes)
                        .frame(height: 100)
                }

                // Visibility
                Section {
                    Toggle("Make Public", isOn: $log.isPublic)
                }

                // Save Button
                Section {
                    Button {
                        saveChanges()
                    } label: {
                        if isSaving {
                            ProgressView()
                        } else {
                            Text("Save Changes")
                        }
                    }
                    .disabled(log.raceName.isEmpty || isSaving)
                }
            }
            .navigationTitle("Edit Race")
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .onAppear {
                selectedRaceType = log.raceType ?? .triathlon
            }
        }
    }

    private func saveChanges() {
        isSaving = true
        log.raceType = selectedRaceType

        viewModel.update(log: log) { success in
            isSaving = false
            if success {
                dismiss()
            } else {
                errorMessage = "Failed to update race. Please try again."
                showError = true
            }
        }
    }
}
