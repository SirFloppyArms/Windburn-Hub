//
//  EditPerformanceView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-07-04.
//

import SwiftUI

struct EditPerformanceView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: StatsViewModel
    @State var log: PerformanceLog
    @State private var isSaving = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Edit Log")) {
                    TextField("Activity", text: $log.activity)
                    TextField("Result", text: $log.result)
                    DatePicker("Date", selection: $log.date, displayedComponents: .date)
                    Toggle("Public", isOn: $log.isPublic)
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
                    .disabled(log.activity.isEmpty || log.result.isEmpty || isSaving)
                }
            }
            .navigationTitle("Edit Performance")
        }
    }

    private func saveChanges() {
        isSaving = true
        viewModel.update(log: log) { success in
            isSaving = false
            if success {
                dismiss()
            } else {
                print("Failed to update log")
                // You could show an alert here if you want
            }
        }
    }
}
