import SwiftUI

// MARK: - Main Detail View

struct ContainerDetailView: View {
    @EnvironmentObject var viewModel: ContainerViewModel
    @State private var selectedTab: DetailTab = .overview

    var body: some View {
        Group {
            if let container = viewModel.selectedContainer {
                VStack(spacing: 0) {
                    GlassTabBar(selectedTab: $selectedTab)
                        .padding(.horizontal)
                        .padding(.top, 10)

                    // Tab Content
                    Group {
                        switch selectedTab {
                        case .overview:
                            ContainerOverviewView(container: container)
                        case .logs:
                            LogView()
                        case .terminal:
                            TerminalView()
                        case .networks:
                            ContainerNetworksView(container: container)
                        case .volumes:
                            ContainerVolumesView(container: container)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                VStack {
                    Image(systemName: "shippingbox.circle")
                        .font(.system(size: 60))
                    Text("Select a container to view details")
                        .font(.title2)
                }
                .foregroundColor(.secondary.opacity(0.6))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding([.top, .trailing, .bottom])
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
        .animation(.easeInOut, value: viewModel.selectedContainerId)
    }
}

// MARK: - Detail Tab Enum & Glass Tab Bar

enum DetailTab: String, CaseIterable {
    case overview = "Overview"
    case logs = "Logs"
    case terminal = "Terminal"
    case networks = "Networks"
    case volumes = "Volumes"

    var icon: String {
        switch self {
        case .overview: "info.circle"
        case .logs: "text.alignleft"
        case .terminal: "terminal"
        case .networks: "network"
        case .volumes: "externaldrive"
        }
    }
}

struct GlassTabBar: View {
    @Binding var selectedTab: DetailTab
    @Namespace private var namespace

    var body: some View {
        HStack(spacing: 20) {
            ForEach(DetailTab.allCases, id: \.self) { tab in
                Button(action: { selectedTab = tab }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.title2)
                        Text(tab.rawValue)
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == tab ? .accentColor : .secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background {
                        if selectedTab == tab {
                            Capsule()
                                .fill(Color.accentColor.opacity(0.4))
                                .glassEffect()
                                .matchedGeometryEffect(id: "selection", in: namespace)
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.rawValue)
                .accessibilityHint("Displays the container's \(tab.rawValue.lowercased()).")
                .accessibilityAddTraits(selectedTab == tab ? .isSelected : [])
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Container details navigation")
    }
}

// MARK: - Refactored Overview View with Gauges

struct ContainerOverviewView: View {
    let container: Container
    @StateObject private var metricsViewModel = MetricsViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(container.name).font(.largeTitle.bold())
                        HStack {
                            Image(systemName: container.status.icon).foregroundColor(container.status.color)
                            Text(container.status.rawValue.capitalized).font(.headline)
                        }
                    }
                    Spacer()
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(container.name), status \(container.status.rawValue)")

                HStack(spacing: 24) {
                    GaugeView(value: metricsViewModel.cpuData.last?.value ?? 0, total: 100, label: "CPU Usage", color: .blue, unit: "%" )
                        .accessibilityLabel("CPU Usage: \(Int(metricsViewModel.cpuData.last?.value ?? 0)) percent")
                    GaugeView(value: metricsViewModel.memoryData.last?.value ?? 0, total: 512, label: "Memory Usage", color: .green, unit: "MB")
                        .accessibilityLabel("Memory Usage: \(Int(metricsViewModel.memoryData.last?.value ?? 0)) megabytes")
                }

                VStack(alignment: .leading, spacing: 16) {
                    InfoRow(label: "Image", value: container.image)
                    Divider()
                    InfoRow(label: "ID", value: String(container.id.uuidString.prefix(12)))
                    Divider()
                    InfoRow(label: "Uptime", value: container.uptime)
                    Divider()
                    InfoRow(label: "Ports", value: container.ports.isEmpty ? "N/A" : container.ports.joined(separator: ", "))
                }
                .padding()
                .background(.black.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Container Information")
            }
            .padding()
        }
    }
}

// MARK: - Previews

struct ContainerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockVM = ContainerViewModel(containerService: MockContainerService())
                let _ = mockVM.selectContainer(id: mockVM.containers.first?.id)
        
        return ContainerDetailView()
            .environmentObject(mockVM)
            .frame(width: 800, height: 700)
            .preferredColorScheme(.dark)
    }
}
