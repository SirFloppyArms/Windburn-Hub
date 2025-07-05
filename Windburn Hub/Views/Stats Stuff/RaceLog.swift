//
//  RaceLogs.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-07-04.
//

import Foundation
import FirebaseFirestore

struct RaceLog: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var userName: String
    var raceName: String
    var raceDate: Date
    var location: String
    var category: String

    var swimTime: String
    var t1Time: String
    var bikeTime: String
    var t2Time: String
    var runTime: String
    var overallTime: String

    var notes: String
    var isPublic: Bool
}
