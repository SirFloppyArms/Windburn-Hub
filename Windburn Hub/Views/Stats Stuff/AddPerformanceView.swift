//
//  AddPerformanceView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import SwiftUI

struct AddPerformanceView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: StatsViewModel
    @ObservedObject var authVM: AuthViewModel

    @State private var activity = ""
    @State private var result = ""
    @State private var date = Date()
    @State private var isPublic = true
    @State private var isSaving = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Performance Info")) {
                    TextField("Activity", text: $activity)
                    TextField("Result", text: $result)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    Toggle("Public", isOn: $isPublic)
                }

                Section {
                    Button {
                        saveLog()
                    } label: {
                        if isSaving {
                            ProgressView()
                        } else {
                            Text("Save Log")
                        }
                    }
                    .disabled(activity.isEmpty || result.isEmpty || isSaving)
                }
            }
            .navigationTitle("Add Performance")
        }
    }

    private func saveLog() {
        guard let userId = authVM.user?.uid else { return }
        isSaving = true

        let newLog = PerformanceLog(
            userId: userId,
            userName: authVM.displayName,
            activity: activity,
            result: result,
            date: date,
            isPublic: isPublic
        )

        viewModel.add(log: newLog) { success in
            isSaving = false
            if success {
                dismiss()
            } else {
                // Optional: show alert on failure
                print("Failed to save log")
            }
        }
    }
}
