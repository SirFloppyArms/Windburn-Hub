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
    @State private var customSegments: [RaceSegment] = []
    @State private var newSegmentName = ""

    var body: some View {
        NavigationStack {
            Form {
                // Race Info
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

                // Split Times
                Section(header: Text("Split Times")) {
                    splitTimeFields(for: selectedRaceType)

                    if selectedRaceType == .triathlon || selectedRaceType == .duathlon || selectedRaceType == .aquabike || selectedRaceType == .other {
                        TextField("Overall Time", text: $overallTime)
                    }
                }

                // Notes
                Section(header: Text("Additional Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }

                // Visibility
                Section {
                    Toggle("Make Public", isOn: $isPublic)
                }

                // Save Button
                Section {
                    Button(action: saveLog) {
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

    // MARK: - Dynamic Split Time Inputs
    @ViewBuilder
    private func splitTimeFields(for type: RaceType) -> some View {
        switch type {
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

        case .cyclingRace:
            TextField("Bike Time", text: $bikeTime)

        case .runningRace:
            TextField("Run Time", text: $runTime)

        case .swim:
            TextField("Swim Time", text: $swimTime)

        case .other:
            ForEach(customSegments) { segment in
                HStack {
                    TextField("\(segment.name) Time", text: binding(for: segment))
                    Spacer()
                    Button {
                        removeSegment(segment)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }

            HStack {
                TextField("New Segment Name", text: $newSegmentName)
                Button {
                    addNewSegment()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                }
                .disabled(newSegmentName.isEmpty)
            }
        }
    }

    // MARK: - Add New Custom Segment
    private func addNewSegment() {
        guard !newSegmentName.isEmpty else { return }
        customSegments.append(RaceSegment(name: newSegmentName, time: ""))
        newSegmentName = ""
    }

    // MARK: - Remove Custom Segment
    private func removeSegment(_ segment: RaceSegment) {
        if let index = customSegments.firstIndex(where: { $0.id == segment.id }) {
            customSegments.remove(at: index)
        }
    }

    // MARK: - Save Race Log
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
            raceType: selectedRaceType,
            customSegments: selectedRaceType == .other ? customSegments : nil
        )

        viewModel.add(log: newLog) { success in
            isSaving = false
            if success {
                dismiss()
            } else {
                errorMessage = "Failed to save race. Please try again."
                showError = true
            }
        }
    }

    // MARK: - Bind Custom Segment Time
    private func binding(for segment: RaceSegment) -> Binding<String> {
        Binding(
            get: { customSegments.first(where: { $0.id == segment.id })?.time ?? "" },
            set: { newValue in
                if let index = customSegments.firstIndex(where: { $0.id == segment.id }) {
                    customSegments[index].time = newValue
                }
            }
        )
    }
}
