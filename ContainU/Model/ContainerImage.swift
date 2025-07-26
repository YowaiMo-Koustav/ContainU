import Foundation
import SwiftUI

/// Represents a container image available on the host. Currently purely mock data.
struct ContainerImage: Identifiable, Hashable {
    let id = UUID()
    let repository: String         // e.g. "nginx"
    let tag: String                // e.g. "latest"
    let size: String               // e.g. "125 MB"
    let created: String            // e.g. "2 days ago"

    /// Convenience for display like `nginx:latest`.
    var fullName: String { "\(repository):\(tag)" }
}
