//
//  CalendarViewModel.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import Foundation
import FirebaseFirestore

class CalendarViewModel: ObservableObject {
    @Published var events: [Event] = []

    private var db = Firestore.firestore()

    func fetchEvents() {
        db.collection("events")
            .order(by: "date", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.events = documents.compactMap { doc in
                    try? doc.data(as: Event.self)
                }
            }
    }

    func events(for date: Date) -> [Event] {
        let calendar = Calendar.current
        return events.filter {
            calendar.isDate($0.date, inSameDayAs: date)
        }
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
