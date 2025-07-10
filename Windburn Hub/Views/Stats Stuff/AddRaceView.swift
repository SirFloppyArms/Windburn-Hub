//
//  AddRaceView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct AddRaceView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: StatsViewModel
    @ObservedObject var authVM: AuthViewModel

    @State private var raceName = ""
    @State private var raceDate = Date()
    @State private var location = ""
    @State private var category = ""

    @State private var swimTime = ""
    @State private var t1Time = ""
    @State private var bikeTime = ""
    @State private var t2Time = ""
    @State private var runTime = ""
    @State private var overallTime = ""

    @State private var notes = ""
    @State private var isPublic = true

    @State private var isSaving = false
    @State private var showError = false
    @State private var errorMessage = ""

    @State private var selectedRaceType: RaceType = .triathlon

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Race Info")) {
                    TextField("Race Name", text: $raceName)
                    DatePicker("Race Date", selection: $raceDate, displayedComponents: .date)
                    TextField("Location", text: $location)
                    TextField("Category", text: $category)

                    Picker("Race Type", selection: $selectedRaceType) {
                        ForEach(RaceType.allCases) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                }

                Section(header: Text("Split Times")) {
                    switch selectedRaceType {
                    case .triathlon:
                        TextField("Swim Time", text: $swimTime)
                        TextField("T1 Time", text: $t1Time)
                        TextField("Bike Time", text: $bikeTime)
                        TextField("T2 Time", text: $t2Time)
                        TextField("Run Time", text: $runTime)
                    case .duathlon:
                        TextField("Run 1 Time", text: $swimTime)
                        TextField("T1 Time", text: $t1Time)
                        TextField("Bike Time", text: $bikeTime)
                        TextField("T2 Time", text: $t2Time)
                        TextField("Run 2 Time", text: $runTime)
                    case .aquabike:
                        TextField("Swim Time", text: $swimTime)
                        TextField("T1 Time", text: $t1Time)
                        TextField("Bike Time", text: $bikeTime)
                    default:
                        TextField("Finish Time", text: $overallTime)
                    }

                    if selectedRaceType == .triathlon || selectedRaceType == .duathlon || selectedRaceType == .aquabike {
                        TextField("Overall Time", text: $overallTime)
                    }
                }

                Section(header: Text("Additional Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }

                Section {
                    Toggle("Make Public", isOn: $isPublic)
                }

                Section {
                    Button {
                        saveLog()
                    } label: {
                        if isSaving {
                            ProgressView()
                        } else {
                            Text("Save Race Log")
                        }
                    }
                    .disabled(raceName.isEmpty || isSaving)
                }
            }
            .navigationTitle("Add Race")
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }

    private func saveLog() {
        guard let userId = authVM.user?.uid else {
            errorMessage = "You must be logged in to save a race."
            showError = true
            return
        }

        isSaving = true

        let newLog = RaceLog(
            userId: userId,
            userName: authVM.displayName,
            raceName: raceName,
            raceDate: raceDate,
            location: location,
            category: category,
            swimTime: swimTime,
            t1Time: t1Time,
            bikeTime: bikeTime,
            t2Time: t2Time,
            runTime: runTime,
            overallTime: overallTime,
            notes: notes,
            isPublic: isPublic,
            raceType: selectedRaceType
        )

        viewModel.add(log: newLog) { success in
            isSaving = false
            if success {
                dismiss()
            } else {
                errorMessage = "Failed to save race. Please try again."
                showError = true
                print("🚨 Add RaceLog failed: \(newLog)")
            }
        }
    }
}
