//
//  StatsViewModel.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-07-04.
//

import Foundation
import Combine

class StatsViewModel: ObservableObject {
    @Published var allLogs: [PerformanceLog] = []
    @Published var myLogs: [PerformanceLog] = []
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private let service = FirestoreService.shared
    let authVM: AuthViewModel

    init(authViewModel: AuthViewModel) {
        self.authVM = authViewModel
        fetchLogs()
    }

    func fetchLogs() {
        isLoading = true
        service.fetchPerformanceLogs { [weak self] logs in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.allLogs = logs
                self.myLogs = logs.filter { $0.userId == self.authVM.user?.uid }
                self.isLoading = false
            }
        }
    }

    // MARK: - Permission Check

    func canEdit(log: PerformanceLog) -> Bool {
        if authVM.role == "coach" || authVM.role == "admin" {
            return true
        }
        return log.userId == authVM.user?.uid
    }

    func canDelete(log: PerformanceLog) -> Bool {
        return canEdit(log: log)
    }

    // MARK: - Filtered Logs Based on Role

    func visibleLogs(for userId: String? = nil) -> [PerformanceLog] {
        allLogs.filter { log in
            // If coach or admin, they can see everything
            if authVM.role == "coach" || authVM.role == "admin" {
                if let userId = userId {
                    return log.userId == userId
                } else {
                    return true
                }
            }

            // If athlete, show public logs or their own logs
            if let userId = userId {
                return (log.userId == userId) && (log.isPublic || log.userId == authVM.user?.uid)
            } else {
                return log.isPublic || log.userId == authVM.user?.uid
            }
        }
    }

    // MARK: - CRUD Methods

    func delete(log: PerformanceLog) {
        guard canDelete(log: log) else { return }
        service.deletePerformanceLog(log) { [weak self] error in
            if error == nil {
                self?.fetchLogs()
            } else {
                print("Error deleting log: \(error!.localizedDescription)")
            }
        }
    }

    func add(log: PerformanceLog, completion: @escaping (Bool) -> Void) {
        service.addPerformanceLog(log) { [weak self] error in
            DispatchQueue.main.async {
                self?.fetchLogs()
                completion(error == nil)
            }
        }
    }

    func update(log: PerformanceLog, completion: @escaping (Bool) -> Void) {
        guard canEdit(log: log) else {
            completion(false)
            return
        }
        service.updatePerformanceLog(log) { [weak self] error in
            DispatchQueue.main.async {
                self?.fetchLogs()
                completion(error == nil)
            }
        }
    }
}
