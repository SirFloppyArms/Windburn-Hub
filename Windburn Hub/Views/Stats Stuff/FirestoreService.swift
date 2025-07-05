//
//  FirestoreService.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-06-30.
//

import Foundation
import FirebaseFirestore

struct PerformanceLog: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var userName: String
    var activity: String
    var result: String
    var date: Date
    var isPublic: Bool
}

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()

    func fetchPerformanceLogs(completion: @escaping ([PerformanceLog]) -> Void) {
        db.collection("performanceLogs")
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    let logs = documents.compactMap {
                        try? $0.data(as: PerformanceLog.self)
                    }
                    completion(logs)
                } else {
                    completion([])
                }
            }
    }

    func addPerformanceLog(_ log: PerformanceLog, completion: @escaping (Error?) -> Void) {
        do {
            _ = try db.collection("performanceLogs").addDocument(from: log, completion: completion)
        } catch {
            completion(error)
        }
    }

    func updatePerformanceLog(_ log: PerformanceLog, completion: @escaping (Error?) -> Void) {
        guard let id = log.id else { return }
        do {
            try db.collection("performanceLogs").document(id).setData(from: log, merge: true, completion: completion)
        } catch {
            completion(error)
        }
    }

    func deletePerformanceLog(_ log: PerformanceLog, completion: @escaping (Error?) -> Void) {
        guard let id = log.id else { return }
        db.collection("performanceLogs").document(id).delete(completion: completion)
    }
}
