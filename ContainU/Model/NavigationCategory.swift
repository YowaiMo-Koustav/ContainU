import Foundation

enum NavigationCategory: String, CaseIterable, Identifiable {
    case containers = "Containers"
    case images = "Images"
    case networks = "Networks"
    case volumes = "Volumes"
    case topology = "Topology"

    var id: String { self.rawValue }

    var systemImage: String {
        switch self {
        case .containers: return "shippingbox"
        case .images: return "photo.stack"
        case .networks: return "network"
        case .volumes: return "externaldrive"
        case .topology: return "diagram"
        }
    }
}
