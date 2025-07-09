//
//  Event.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import Foundation
import FirebaseFirestore

extension Date {
    var startOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
}

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
