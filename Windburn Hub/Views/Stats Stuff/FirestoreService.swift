//
//  FirestoreService.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()

    // Fetch all race logs
    func fetchRaceLogs(completion: @escaping ([RaceLog]) -> Void) {
        db.collection("raceLogs")
            .order(by: "raceDate", descending: true)
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    let logs = documents.compactMap {
                        try? $0.data(as: RaceLog.self)
                    }
                    completion(logs)
                } else {
                    completion([])
                }
            }
    }

    // Add a race log
    func addRaceLog(_ log: RaceLog, completion: @escaping (Error?) -> Void) {
        do {
            _ = try db.collection("raceLogs").addDocument(from: log, completion: completion)
        } catch {
            completion(error)
        }
    }

    // Update a race log
    func updateRaceLog(_ log: RaceLog, completion: @escaping (Error?) -> Void) {
        guard let id = log.id else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing document ID"]))
            return
        }
        do {
            try db.collection("raceLogs").document(id).setData(from: log, merge: true, completion: completion)
        } catch {
            completion(error)
        }
    }

    // Delete a race log
    func deleteRaceLog(_ log: RaceLog, completion: @escaping (Error?) -> Void) {
        guard let id = log.id else {
            completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing document ID"]))
            return
        }
        db.collection("raceLogs").document(id).delete(completion: completion)
    }
}
