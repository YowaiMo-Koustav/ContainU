import Foundation

struct Network: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var driver: String
    var subnet: String
    var scope: String
    var attachable: Bool
    var `internal`: Bool
    var containers: [UUID] = []
}
