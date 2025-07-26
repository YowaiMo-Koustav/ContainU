import SwiftUI

/// Displays all mounted volumes for the selected container.
/// Mock implementation: chooses volumes whose name contains container name keyword.
struct ContainerVolumesView: View {
    @EnvironmentObject var viewModel: ContainerViewModel
    let container: Container

    // Resolve volumes linked to this container.
    private var attachedVolumes: [Volume] {
        if !container.volumes.isEmpty {
            return viewModel.volumes.filter { container.volumes.contains($0.name) }
        } else {
            // Fallback heuristic for demo data
            return viewModel.volumes.filter { volume in
                volume.name.localizedCaseInsensitiveContains(container.name.components(separatedBy: "-").first ?? "")
            }
        }
    }

    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading volumes...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityLabel("Loading container volumes")
            } else if attachedVolumes.isEmpty {
                Text("No volumes mounted")
                    .foregroundColor(.secondary)
                    .padding()
                    .accessibilityLabel("This container has no volumes mounted.")
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(attachedVolumes) { volume in
                            VolumeRowView(volume: volume)
                                .glassEffect()
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            if isLoading {
                try? await Task.sleep(nanoseconds: 500_000_000)
                withAnimation { isLoading = false }
            }
        }
    }
}

struct ContainerVolumesView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ContainerViewModel(containerService: MockContainerService())
        return ContainerVolumesView(container: vm.containers.first!)
            .environmentObject(vm)
    }
}
