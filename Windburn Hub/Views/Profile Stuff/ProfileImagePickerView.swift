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

    let imageOptions = ["default", "bike1", "run1", "swim1", "windburn"]

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
