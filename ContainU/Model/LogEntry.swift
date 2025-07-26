import SwiftUI

struct LogEntry: Identifiable, Hashable {
    let id = UUID()
    let timestamp: Date
    let message: String
    let level: LogLevel
}

enum LogLevel: String, CaseIterable, Identifiable {
    case info = "INFO"
    case warning = "WARN"
    case error = "ERROR"
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .info: return .primary
        case .warning: return .orange
        case .error: return .red
        }
    }
}
