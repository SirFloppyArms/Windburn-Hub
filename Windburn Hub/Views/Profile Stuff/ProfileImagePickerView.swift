//
//  ProfileImagePickerView.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-07-01.
//

import SwiftUI

struct ProfileImagePickerView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss

    let imageOptions = ["run1", "run2", "run3", "bike1", "bike2", "swim1", "swim2", "swim3", "winner", "windburn", "tri", "runswim", "podium", "finisher", "strong"]

    var body: some View {
        List {
            ForEach(imageOptions, id: \.self) { imageName in
                HStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())

                    Text(imageName.capitalized)
                        .padding(.leading, 10)

                    Spacer()

                    if authViewModel.profileImageName == imageName {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    authViewModel.updateProfileImage(name: imageName)
                    dismiss()
                }
            }
        }
        .navigationTitle("Select Image")
    }
}
