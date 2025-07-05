//
//  CalendarViewModel.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import Foundation
import FirebaseFirestore

enum CalendarItem: Identifiable {
    case event(Event)
    case race(RaceLog)

    var id: String {
        switch self {
        case .event(let event): return event.id ?? UUID().uuidString
        case .race(let race): return race.id ?? UUID().uuidString
        }
    }

    var title: String {
        switch self {
        case .event(let event): return event.title
        case .race(let race): return race.raceName
        }
    }

    var date: Date {
        switch self {
        case .event(let event): return event.date
        case .race(let race): return race.raceDate
        }
    }

    var typeIcon: String {
        switch self {
        case .event: return "calendar"
        case .race: return "flag.checkered"
        }
    }
}

class CalendarViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var raceLogs: [RaceLog] = []

    private let db = Firestore.firestore()
    private var authVM: AuthViewModel

    init(authVM: AuthViewModel) {
        self.authVM = authVM
        fetchAll()
    }

    func fetchAll() {
        fetchEvents()
        fetchRaceLogs()
    }

    func fetchEvents() {
        db.collection("events")
            .order(by: "date", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.events = documents.compactMap {
                    try? $0.data(as: Event.self)
                }
            }
    }

    func fetchRaceLogs() {
        db.collection("raceLogs")
            .order(by: "raceDate", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                let allLogs = docs.compactMap { try? $0.data(as: RaceLog.self) }

                DispatchQueue.main.async {
                    if self.authVM.role == "coach" || self.authVM.role == "admin" {
                        self.raceLogs = allLogs
                    } else if let uid = self.authVM.user?.uid {
                        self.raceLogs = allLogs.filter { $0.userId == uid }
                    } else {
                        self.raceLogs = []
                    }
                }
            }
    }

    func calendarItems(for date: Date) -> [CalendarItem] {
        let calendar = Calendar.current

        let dayEvents = events.filter {
            calendar.isDate($0.date, inSameDayAs: date)
        }.map { CalendarItem.event($0) }

        let dayRaces = raceLogs.filter {
            calendar.isDate($0.raceDate, inSameDayAs: date)
        }.map { CalendarItem.race($0) }

        return dayEvents + dayRaces
    }

    func addEvent(_ event: Event) {
        do {
            _ = try db.collection("events").addDocument(from: event)
        } catch {
            print("Error adding event: \(error)")
        }
    }

    func updateEvent(_ event: Event) {
        guard let id = event.id else { return }
        do {
            try db.collection("events").document(id).setData(from: event)
        } catch {
            print("Error updating event: \(error)")
        }
    }

    func deleteEvent(_ event: Event) {
        guard let id = event.id else { return }
        db.collection("events").document(id).delete()
    }
}
