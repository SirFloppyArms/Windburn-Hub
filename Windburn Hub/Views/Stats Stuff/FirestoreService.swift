//
//  FirestoreService.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import Foundation
import FirebaseFirestore

struct Performance: Identifiable, Codable {
    @DocumentID var id: String?
    var userID: String
    var athleteName: String
    var eventType: String // "Race" or "Training"
    var sport: String // "Triathlon", "Run", etc.
    var distance: Double
    var time: Int // In seconds
    var location: String
    var date: Date
    var notes: String
    var createdAt: Date
}

class FirestoreService {
    static let shared = FirestoreService()
    private init() {}

    private let db = Firestore.firestore()

    func addPerformance(_ performance: Performance, completion: @escaping (Error?) -> Void) {
        do {
            _ = try db.collection("performances").addDocument(from: performance)
            completion(nil)
        } catch {
            completion(error)
        }
    }

    func fetchPerformances(for userID: String, completion: @escaping ([Performance]) -> Void) {
        db.collection("performances")
            .whereField("userID", isEqualTo: userID)
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching performances: \(error)")
                    completion([])
                    return
                }

                let performances = snapshot?.documents.compactMap { document in
                    try? document.data(as: Performance.self)
                } ?? []

                completion(performances)
            }
    }
}
