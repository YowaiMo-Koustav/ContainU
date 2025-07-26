import SwiftUI

/// Displays all networks the selected container is attached to.
struct ContainerNetworksView: View {
    @EnvironmentObject var viewModel: ContainerViewModel
    let container: Container

    @State private var isLoading = true
    
    var body: some View {
        Group {
            // Loading state and content
            if isLoading {
                ProgressView("Loading networks...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityLabel("Loading container networks")
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(container.networks, id: \.self) { name in
                            if let network = viewModel.networks.first(where: { $0.name == name }) {
                                NetworkRowView(network: network)
                            } else {
                                HStack {
                                    Image(systemName: "network")
                                        .font(.largeTitle)
                                        .foregroundColor(.blue)
                                        .frame(width: 50)
                                    Text(name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding()
                                .glassEffect()
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("Network: \(name)")
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Networks")
        .task {
            // Simulate data fetch delay
            if isLoading {
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s delay
                withAnimation { isLoading = false }
            }
        }
    }
}

struct ContainerNetworksView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ContainerViewModel(containerService: MockContainerService())
        return ContainerNetworksView(container: vm.containers.first!)
            .environmentObject(vm)
    }
}
