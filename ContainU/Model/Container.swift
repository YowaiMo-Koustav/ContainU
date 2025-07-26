import Foundation
import SwiftUI

// Enum for Container Status
enum ContainerStatus: String, CaseIterable, Identifiable {
    case pulling = "Pulling"
    case running = "Running"
    case stopped = "Stopped"
    case error = "Error"
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .pulling:
            return .blue
        case .running:
            return .green
        case .stopped:
            return .gray
        case .error:
            return .red
        }
    }
    
    var icon: String {
        switch self {
        case .pulling:
            return "arrow.down.circle.fill"
        case .running:
            return "play.circle.fill"
        case .stopped:
            return "stop.circle.fill"
        case .error:
            return "exclamationmark.circle.fill"
        }
    }
}

// Struct for Container
struct Container: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var image: String
    var status: ContainerStatus
    var uptime: String
    var cpuUsage: Double
    var memoryUsage: String
    var ports: [String]
    var networks: [String]
    var volumes: [String] = []
}
