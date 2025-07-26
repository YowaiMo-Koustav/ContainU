import SwiftUI

struct NetworkTopologyView: View {
    @EnvironmentObject var viewModel: ContainerViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Rectangle().fill(.ultraThinMaterial).ignoresSafeArea()
                LinearGradient(colors: [.accentColor.opacity(0.1), .clear], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                let (networkNodes, containerNodes) = calculateInitialPositions(in: geometry.size)

                // Draw connection lines
                ForEach(viewModel.containers) { container in
                    // Changed ForEach over dictionary keys to Array with id: \.self to fix UUID ForEach issue
                    if let containerPosition = containerNodes[container.id] {
                            ForEach(container.networks, id: \.self) { networkName in
                            if let networkPosition = networkNodes.first(where: { $0.name == networkName })?.position {
                                ConnectionLine(startPoint: containerPosition, endPoint: networkPosition)
                            }
                        }
                    }
                }
                
                // Draw nodes
                // Network nodes are drawn here; container nodes are handled by connection lines and overlays
                ForEach(networkNodes) { node in
                    TopologyNodeView(node: node)
                }
            }
        }
        .navigationTitle("Topology")
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Network Topology: showing \(viewModel.containers.count) containers and \(viewModel.networks.count) networks.")
    }

    private func calculateInitialPositions(in size: CGSize) -> (networkNodes: [TopologyNode], containerNodes: [UUID: CGPoint]) {
        // Networks (centered horizontally)
        let networks = viewModel.networks
        var networkNodes: [TopologyNode] = []
        let networkYSpacing = size.height / CGFloat(networks.count + 1)
        for (index, network) in networks.enumerated() {
            let y = networkYSpacing * CGFloat(index + 1)
            let position = CGPoint(x: size.width / 2, y: y)
            networkNodes.append(TopologyNode(id: network.id, name: network.name, systemImage: "network", color: .accentColor, position: position, type: .network))
        }

        // Containers (sides)
        let containers = viewModel.containers
        var containerNodes: [UUID: CGPoint] = [:]
        let containerYSpacing = size.height / CGFloat(containers.count + 1)
        for (index, container) in containers.enumerated() {
            let y = containerYSpacing * CGFloat(index + 1)
            let x = (index % 2 == 0) ? size.width * 0.2 : size.width * 0.8
            containerNodes[container.id] = CGPoint(x: x, y: y)
        }
        
        return (networkNodes, containerNodes)
    }
}

// MARK: - Helper Structs & Views

struct TopologyNode: Identifiable {
    enum NodeType { case container, network }
    let id: UUID
    let name: String
    let systemImage: String
    let color: Color
    var position: CGPoint
    let type: NodeType
}

struct TopologyNodeView: View {
    let node: TopologyNode
    @EnvironmentObject var viewModel: ContainerViewModel
    @State private var isHovered = false

    private var connectionsHint: String {
        switch node.type {
        case .container:
            guard let container = viewModel.containers.first(where: { $0.id == node.id }) else { return "" }
            let networkNames = container.networks.joined(separator: ", ")
            return networkNames.isEmpty ? "Not connected to any networks." : "Connected to networks: \(networkNames)."
        case .network:
            let containerNames = viewModel.containers.filter { container in
                container.networks.contains(node.name)
            }.map { $0.name }.joined(separator: ", ")
            return containerNames.isEmpty ? "Not connected to any containers." : "Connected to containers: \(containerNames)."
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: node.systemImage)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(node.color)
            Text(node.name)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
                .truncationMode(.middle)
        }
        .padding()
        .frame(width: 140, height: 80)
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(node.color.opacity(isHovered ? 0.8 : 0.4), lineWidth: 2)
        )
        .shadow(color: .black.opacity(isHovered ? 0.3 : 0.15), radius: isHovered ? 12 : 6)
        .scaleEffect(isHovered ? 1.1 : 1.0)
        .position(node.position)
        .onHover { hovering in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isHovered = hovering
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(node.type == .container ? "Container" : "Network"): \(node.name)")
        .accessibilityHint(connectionsHint)
    }
}

struct ConnectionLine: View {
    let startPoint: CGPoint
    let endPoint: CGPoint

    var body: some View {
        Path { path in
            path.move(to: startPoint)
            path.addLine(to: endPoint)
        }
        .stroke(
            LinearGradient(
                gradient: Gradient(colors: [.secondary.opacity(0.1), .secondary.opacity(0.5), .secondary.opacity(0.1)]),
                startPoint: .leading,
                endPoint: .trailing
            ),
            style: StrokeStyle(lineWidth: 2.5, lineCap: .round, dash: [5, 5])
        )
    }
}

struct NetworkTopologyView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkTopologyView()
            .environmentObject(ContainerViewModel(containerService: MockContainerService()))
            .frame(height: 600)
    }
}
