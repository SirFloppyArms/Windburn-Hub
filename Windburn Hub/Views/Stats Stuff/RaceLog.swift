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
        case .triathlon: return "Tri"
        case .duathlon: return "Du"
        case .aquabike: return "Aquabike"
        case .runningRace: return "Run"
        case .cyclingRace: return "Bike"
        case .swim: return "Swim"
        case .other: return "Other"
        }
    }
}

struct RaceSegment: Identifiable, Codable {
    var id = UUID().uuidString
    var name: String
    var time: String
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
    var customSegments: [RaceSegment]?
}
