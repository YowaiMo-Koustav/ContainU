import SwiftUI

struct NetworkListView: View {
    @EnvironmentObject var viewModel: ContainerViewModel

    var body: some View {
        HSplitView {
            networkList
                .frame(minWidth: 250, idealWidth: 300, maxWidth: 400)
            
            if let network = viewModel.selectedNetwork {
                NetworkDetailView(network: network)
                    .frame(maxWidth: .infinity)
            } else {
                VStack {
                    Text("No Network Selected")
                        .font(.title)
                        .foregroundColor(.secondary)
                    Text("Please select a network from the list.")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Material.ultraThin)
        .navigationTitle("Networks")
    }
    
    private var networkList: some View {
        List(selection: $viewModel.selectedNetworkId) {
            ForEach(viewModel.networks) { network in
                NetworkRowView(network: network)
                    .tag(network.id)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .background(.clear)
    }
}

struct NetworkRowView: View {
    let network: Network
    @EnvironmentObject var viewModel: ContainerViewModel
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "network")
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 25)

            VStack(alignment: .leading) {
                Text(network.name).fontWeight(.medium)
                Text("Driver: \(network.driver)").font(.caption).foregroundColor(.secondary)
            }

            Spacer()

            Text(network.scope)
                .font(.caption)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.primary.opacity(0.1))
                .clipShape(Capsule())
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(viewModel.selectedNetworkId == network.id ? Color.accentColor.opacity(0.6) : isHovered ? .primary.opacity(0.15) : .clear)
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.1)) { isHovered = hovering }
        }
        .contextMenu {
            Button(role: .destructive) { Task { await viewModel.removeNetwork(network) } } label: { Label("Remove Network", systemImage: "trash") }
                .accessibilityLabel("Remove network \(network.name)")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Network \(network.name), driver \(network.driver), scope \(network.scope)")
        .accessibilityHint("Selects the network and shows details.")
    }
}

struct NetworkDetailView: View {
    let network: Network
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text(network.name)
                    .font(.title.bold())
                Text(network.id.uuidString)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
                    .textSelection(.enabled)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Network name: \(network.name). ID: \(network.id)")
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                InfoRow(label: "Driver", value: network.driver)
                InfoRow(label: "Scope", value: network.scope)
                InfoRow(label: "Attachable", value: network.attachable ? "Yes" : "No")
                InfoRow(label: "Internal", value: network.internal ? "Yes" : "No")
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Network Details")
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Material.thick, in: RoundedRectangle(cornerRadius: 12))
        .padding()
    }
}

struct NetworkListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ContainerViewModel(containerService: MockContainerService())
        viewModel.selectedNetworkId = viewModel.networks.first?.id
        
        return NetworkListView()
            .environmentObject(viewModel)
            .frame(width: 800, height: 500)
    }
}
