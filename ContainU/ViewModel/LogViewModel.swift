import SwiftUI
import Combine

@MainActor
class LogViewModel: ObservableObject {
    // MARK: - Service Dependencies
    #if FAKE_BACKEND
    @EnvironmentObject var containerService: MockContainerService
    #else
    @EnvironmentObject var containerService: ContainerService
    #endif
    
    @Published var allLogs: [LogEntry] = []
    @Published var filteredLogs: [LogEntry] = []
    @Published var currentContainer: Container?
    
    @Published var searchText: String = "" {
        didSet {
            filterLogs()
        }
    }
    
    @Published var selectedLevels: Set<LogLevel> = Set(LogLevel.allCases) {
        didSet {
            filterLogs()
        }
    }
    
    init() {
        loadLogs()
    }
    
    func loadLogs() {
        #if FAKE_BACKEND
        allLogs = FakeData.generateRandomLogs()
        #else
        // Real implementation would load from service
        #endif
        filterLogs()
    }
    
    func loadLogs(for container: Container) async {
        currentContainer = container
        
        #if FAKE_BACKEND
        do {
            let logs = try await containerService.fetchLogs(for: container)
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.3)) {
                    allLogs = logs
                    filterLogs()
                }
            }
        } catch {
            print("Failed to load logs for container: \(error)")
        }
        #else
        // Real implementation would go here
        #endif
    }
    
    func filterLogs() {
        var logs = allLogs
        
        if !searchText.isEmpty {
            logs = logs.filter { $0.message.localizedCaseInsensitiveContains(searchText) }
        }
        
        logs = logs.filter { selectedLevels.contains($0.level) }
        
        withAnimation {
            filteredLogs = logs
        }
    }
}
