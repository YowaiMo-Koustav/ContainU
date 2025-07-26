import Foundation

enum ContainerSortOption: String, CaseIterable, Identifiable {
    case name = "Name"
    case status = "Status"
    case uptime = "Uptime"

    var id: String { rawValue }
}
