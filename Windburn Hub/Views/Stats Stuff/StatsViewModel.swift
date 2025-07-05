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
    private let authVM: AuthViewModel

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

    func canEdit(log: PerformanceLog) -> Bool {
        return authVM.role == "coach" || authVM.role == "admin" || log.userId == authVM.user?.uid
    }

    func visibleLogs(for userId: String? = nil) -> [PerformanceLog] {
        return allLogs.filter { log in
            if let userId = userId {
                return log.userId == userId && (log.isPublic || canEdit(log: log))
            } else {
                return log.isPublic || canEdit(log: log)
            }
        }
    }

    func delete(log: PerformanceLog) {
        service.deletePerformanceLog(log) { [weak self] error in
            if error == nil {
                self?.fetchLogs()
            }
        }
    }
}
