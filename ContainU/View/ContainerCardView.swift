import SwiftUI

struct ContainerCardView: View {
    @EnvironmentObject var viewModel: ContainerViewModel
    let container: Container
    var namespace: Namespace.ID
    let action: () -> Void
    
    @State private var isHovered = false

    var body: some View {
        cardContent
            .padding(16)
            .background(Material.thick, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(cardOverlay)
            .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
            .scaleEffect(isHovered ? 1.03 : 1.0)
            .onTapGesture(perform: action)
            .onHover(perform: handleHover)
            .contextMenu { cardContextMenu }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(accessibilityText)
            .accessibilityHint("Double-tap to select and view details.")
    }
    
    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerRow
            metricsRow
        }
    }
    
    private var headerRow: some View {
        HStack {
            containerIcon
            containerInfo
            Spacer()
            statusPill
        }
    }
    
    private var containerIcon: some View {
        Image(systemName: container.status.icon)
            .font(.title2)
            .foregroundColor(container.status.color)
            .frame(width: 25, height: 25)
            .matchedGeometryEffect(id: "container.icon.\(container.id)", in: namespace)
    }
    
    private var containerInfo: some View {
        VStack(alignment: .leading) {
            Text(container.name)
                .fontWeight(.bold)
                .lineLimit(1)
                .matchedGeometryEffect(id: "container.name.\(container.id)", in: namespace)
            Text(container.image)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .matchedGeometryEffect(id: "container.image.\(container.id)", in: namespace)
        }
    }
    
    private var statusPill: some View {
        StatusPill(status: container.status)
            .matchedGeometryEffect(id: "container.status.\(container.id)", in: namespace)
    }
    
    private var metricsRow: some View {
        HStack(spacing: 16) {
            cpuGauge
            memoryGauge
        }
        .padding(.top, 8)
    }
    
    private var cpuGauge: some View {
        Gauge(value: container.cpuUsage, in: 0...1) {
            Text("CPU")
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(.cyan)
        .accessibilityLabel("CPU usage: \(Int(container.cpuUsage * 100)) percent")
    }
    
    private var memoryGauge: some View {
        Gauge(value: memoryUsagePercentage, in: 0...1) {
            Text("Mem")
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(.purple)
        .accessibilityLabel("Memory usage: \(Int(memoryUsagePercentage * 100)) percent")
    }
    
    private var cardOverlay: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .stroke(isHovered ? Color.primary.opacity(0.2) : Color.clear, lineWidth: 1)
    }
    
    private var cardContextMenu: some View {
        Group {
            Button { Task { await viewModel.startContainer(id: container.id) } } label: { Label("Start", systemImage: "play.fill") }.accessibilityLabel("Start container \(container.name)")
            Button { Task { await viewModel.stopContainer(id: container.id) } } label: { Label("Stop", systemImage: "stop.fill") }.accessibilityLabel("Stop container \(container.name)")
            Button { Task { await viewModel.restartContainer(id: container.id) } } label: { Label("Restart", systemImage: "arrow.clockwise") }.accessibilityLabel("Restart container \(container.name)")
            Divider()
            Button(role: .destructive) { Task { await viewModel.deleteContainer(id: container.id) } } label: { Label("Delete", systemImage: "trash") }.accessibilityLabel("Delete container \(container.name)")
        }
    }
    
    private var accessibilityText: String {
        "\(container.name), status \(container.status.rawValue). CPU: \(Int(container.cpuUsage * 100))%, Memory: \(Int(memoryUsagePercentage * 100))%"
    }
    
    private var memoryUsagePercentage: Double {
        // Extract numeric value from memory usage string (e.g., "256 MB" -> 0.25 for 25%)
        // This is a simplified conversion for demo purposes
        let components = container.memoryUsage.components(separatedBy: " ")
        if let valueString = components.first, let value = Double(valueString) {
            // Assume values are in MB and convert to a percentage (simplified)
            // In a real app, you'd have proper memory calculation logic
            return min(value / 1024.0, 1.0) // Convert MB to GB ratio, capped at 100%
        }
        return 0.0
    }
    
    private func handleHover(_ hovering: Bool) {
        withAnimation(.spring()) {
            isHovered = hovering
        }
    }
}

struct ContainerCardView_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        let service = MockContainerService()
        let container = service.containers.first!
        ContainerCardView(container: container, namespace: namespace, action: {})
            .environmentObject(ContainerViewModel(containerService: service))
            .frame(width: 260, height: 150)
            .padding()
    }
}
