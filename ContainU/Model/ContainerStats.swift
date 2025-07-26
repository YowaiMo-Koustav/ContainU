import Foundation

/// Represents a single snapshot of resource usage for a container.
struct ContainerStats: Identifiable {
    let id = UUID()
    let timestamp: Date
    /// CPU usage in percentage (0-100)
    let cpu: Double
    /// Memory usage in MB
    let memory: Double
    /// Network I/O in MB/s (combined in+out)
    let networkIO: Double
}
