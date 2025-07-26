import SwiftUI
import Combine

@MainActor
class MetricsViewModel: ObservableObject {
    // MARK: - Service Dependencies
    #if FAKE_BACKEND
    @EnvironmentObject var containerService: MockContainerService
    #else
    @EnvironmentObject var containerService: ContainerService
    #endif
    
    @Published var cpuData: [MetricDataPoint] = []
    @Published var memoryData: [MetricDataPoint] = []
    @Published var networkData: [MetricDataPoint] = []
    @Published var currentContainer: Container?

    private var timer: Timer?

    init() {
        loadInitialData()
        startUpdatingData()
    }

    deinit {
        timer?.invalidate()
    }

    func loadInitialData() {
        #if FAKE_BACKEND
        cpuData = FakeData.generateMetricData()
        memoryData = FakeData.generateMetricData()
        networkData = FakeData.generateMetricData()
        #else
        // Real implementation would load from service
        #endif
    }
    
    func loadMetrics(for container: Container) async {
        currentContainer = container
        
        #if FAKE_BACKEND
        do {
            let stats = try await containerService.getContainerStats(for: container)
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.3)) {
                    // Convert stats to metric data points
                    let now = Date()
                    cpuData.append(MetricDataPoint(date: now, value: stats.cpu))
                    memoryData.append(MetricDataPoint(date: now, value: stats.memory))
                    networkData.append(MetricDataPoint(date: now, value: stats.networkIO))
                    
                    // Keep only last 60 data points
                    if cpuData.count > 60 { cpuData.removeFirst() }
                    if memoryData.count > 60 { memoryData.removeFirst() }
                    if networkData.count > 60 { networkData.removeFirst() }
                }
            }
        } catch {
            print("Failed to load metrics for container: \(error)")
        }
        #else
        // Real implementation would go here
        #endif
    }

    func startUpdatingData() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            Task {
                await self?.updateData()
            }
        }
    }

    private func updateData() {
        withAnimation {
            if !cpuData.isEmpty {
                cpuData.removeFirst()
                let lastDate = cpuData.last?.date ?? Date()
                let newValue = Double.random(in: 5...85)
                cpuData.append(MetricDataPoint(date: lastDate.addingTimeInterval(60), value: newValue))
            }
            
            if !memoryData.isEmpty {
                memoryData.removeFirst()
                let lastDate = memoryData.last?.date ?? Date()
                let newValue = Double.random(in: 10...70)
                memoryData.append(MetricDataPoint(date: lastDate.addingTimeInterval(60), value: newValue))
            }

            if !networkData.isEmpty {
                networkData.removeFirst()
                let lastDate = networkData.last?.date ?? Date()
                let newValue = Double.random(in: 1...20)
                networkData.append(MetricDataPoint(date: lastDate.addingTimeInterval(60), value: newValue))
            }
        }
    }
}
