import Foundation

struct Volume: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var driver: String
    var size: String
    var mountPoint: String
    var containers: [UUID] = []
}
