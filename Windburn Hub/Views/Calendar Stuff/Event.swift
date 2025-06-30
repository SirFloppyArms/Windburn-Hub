//
//  Event.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import Foundation
import FirebaseFirestore

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var date: Date
    var type: String
    var location: String
    var registrationLink: String
    var courseMapURL: String
    var details: String
}
