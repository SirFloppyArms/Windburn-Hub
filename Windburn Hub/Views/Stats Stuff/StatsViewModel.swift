//
//  StatsViewModel.swift
//  Windburn Hub
//
//  Created by Nolan Law on 2025-07-04.
//

import Foundation
import Combine

class StatsViewModel: ObservableObject {
    @Published var allLogs: [RaceLog] = []
    @Published var myLogs: [RaceLog] = []
    @Published var isLoading: Bool = false

    let authVM: AuthViewModel
    private var cancellables = Set<AnyCancellable>()
    private let service = FirestoreService.shared

    init(authViewModel: AuthViewModel) {
        self.authVM = authViewModel
        fetchLogs()
    }

    func fetchLogs() {
        isLoading = true
        service.fetchRaceLogs { [weak self] logs in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.allLogs = logs
                self.myLogs = logs.filter { $0.userId == self.authVM.user?.uid }
                self.isLoading = false
            }
        }
    }

    func add(log: RaceLog, completion: @escaping (Bool) -> Void) {
        service.addRaceLog(log) { error in
            DispatchQueue.main.async {
                if error == nil {
                    self.fetchLogs()
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

    func update(log: RaceLog, completion: @escaping (Bool) -> Void) {
        service.updateRaceLog(log) { error in
            DispatchQueue.main.async {
                if error == nil {
                    self.fetchLogs()
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

    func delete(log: RaceLog) {
        service.deleteRaceLog(log) { [weak self] error in
            if error == nil {
                self?.fetchLogs()
            }
        }
    }

    func canEdit(log: RaceLog) -> Bool {
        return authVM.role == "coach" || authVM.role == "admin" || log.userId == authVM.user?.uid
    }

    func canDelete(log: RaceLog) -> Bool {
        return authVM.role == "coach" || authVM.role == "admin" || log.userId == authVM.user?.uid
    }

    func visibleLogs(for userId: String? = nil) -> [RaceLog] {
        return allLogs.filter { log in
            if let userId = userId {
                return log.userId == userId && (log.isPublic || canEdit(log: log))
            } else {
                return log.isPublic || canEdit(log: log)
            }
        }
    }
}
