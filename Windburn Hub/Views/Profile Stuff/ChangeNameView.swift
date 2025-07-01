//
//  ChangeNameView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-07-01.
//

import SwiftUI

struct ChangeNameView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var newName: String = ""

    var body: some View {
        Form {
            Section {
                TextField("New Name", text: $newName)
            }

            Button("Update Name") {
                authViewModel.updateDisplayName(to: newName)
                dismiss()
            }
        }
        .navigationTitle("Change Name")
    }
}
