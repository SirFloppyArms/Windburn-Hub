//
//  RaceLogs.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-07-04.
//

import Foundation
import FirebaseFirestore

enum RaceType: String, Codable, CaseIterable, Identifiable {
    case triathlon
    case duathlon
    case aquabike
    case runningRace
    case cyclingRace
    case swim
    case other

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .triathlon: return "Triathlon"
        case .duathlon: return "Duathlon"
        case .aquabike: return "Aquabike"
        case .runningRace: return "Running Race"
        case .cyclingRace: return "Cycling Race"
        case .swim: return "Swim Competition"
        case .other: return "Other"
        }
    }
}

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

    var raceType: RaceType
}
