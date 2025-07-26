import Foundation

struct MetricDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
