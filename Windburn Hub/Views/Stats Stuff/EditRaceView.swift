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

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Race Info")) {
                    TextField("Race Name", text: $log.raceName)
                    DatePicker("Race Date", selection: $log.raceDate, displayedComponents: .date)
                    TextField("Location", text: $log.location)
                    TextField("Category", text: $log.category)
                }

                Section(header: Text("Split Times")) {
                    TextField("Swim Time", text: $log.swimTime)
                    TextField("T1 Time", text: $log.t1Time)
                    TextField("Bike Time", text: $log.bikeTime)
                    TextField("T2 Time", text: $log.t2Time)
                    TextField("Run Time", text: $log.runTime)
                    TextField("Overall Time", text: $log.overallTime)
                }

                Section(header: Text("Additional Notes")) {
                    TextEditor(text: $log.notes)
                        .frame(height: 100)
                }

                Section {
                    Toggle("Make Public", isOn: $log.isPublic)
                }

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
        }
    }

    private func saveChanges() {
        isSaving = true
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
