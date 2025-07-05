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

    var body: some View {
        Form {
            Section(header: Text("Edit Log")) {
                TextField("Activity", text: $log.activity)
                TextField("Result", text: $log.result)
                DatePicker("Date", selection: $log.date, displayedComponents: .date)
                Toggle("Public", isOn: $log.isPublic)
            }

            Button("Save Changes") {
                FirestoreService.shared.updatePerformanceLog(log) { error in
                    if error == nil {
                        viewModel.fetchLogs()
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Edit Performance")
    }
}
