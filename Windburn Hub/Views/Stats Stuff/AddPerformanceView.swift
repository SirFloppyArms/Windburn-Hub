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

    var body: some View {
        Form {
            Section(header: Text("Performance Info")) {
                TextField("Activity", text: $activity)
                TextField("Result", text: $result)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                Toggle("Public", isOn: $isPublic)
            }

            Button("Save Log") {
                let log = PerformanceLog(
                    userId: authVM.user?.uid ?? "",
                    userName: authVM.displayName,
                    activity: activity,
                    result: result,
                    date: date,
                    isPublic: isPublic
                )

                FirestoreService.shared.addPerformanceLog(log) { error in
                    if error == nil {
                        viewModel.fetchLogs()
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Add Performance")
    }
}
