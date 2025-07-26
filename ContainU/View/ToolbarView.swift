import SwiftUI

struct ToolbarView: View {
    @EnvironmentObject var viewModel: ContainerViewModel


    var body: some View {
        HStack(spacing: 12) {
            // Search Field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search...", text: $viewModel.searchQuery)
                    .textFieldStyle(.plain)
                    .accessibilityLabel("Search for containers, images, networks, or volumes")
                    
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(maxWidth: 250)

            Spacer()

            // Main Actions
            HStack(spacing: 0) {
                ToolbarButton(systemImage: "play.fill", tooltip: "Start", accessibilityLabel: "Start selected container") {
                    Task { await viewModel.startSelectedOrCurrent() }
                }
                .disabled(viewModel.selectedContainer?.status == .running)

                ToolbarButton(systemImage: "stop.fill", tooltip: "Stop", accessibilityLabel: "Stop selected container") {
                    Task { await viewModel.stopSelectedOrCurrent() }
                }
                .disabled(viewModel.selectedContainer?.status == .stopped)

                ToolbarButton(systemImage: "arrow.clockwise", tooltip: "Restart", accessibilityLabel: "Restart selected container") {
                    Task { await viewModel.restartSelectedOrCurrent() }
                }

                ToolbarButton(systemImage: "trash", tooltip: "Delete", accessibilityLabel: "Delete selected container") {
                    Task { await viewModel.deleteSelectedOrCurrent() }
                }
            }
            .disabled(viewModel.selectedContainerId == nil && viewModel.selectedContainers.isEmpty)

            // View Mode Toggle
            Picker("View Mode", selection: $viewModel.viewMode) {
                Label("List", systemImage: "list.bullet").tag(ViewMode.list)
                Label("Grid", systemImage: "square.grid.2x2").tag(ViewMode.grid)
            }
            .pickerStyle(.segmented)
            .frame(width: 100)
            .accessibilityLabel("Switch between list and grid view")

            Spacer()

            // Add Container & Status
            HStack {
                Button(action: { viewModel.showCreateSheet() }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
                .shadow(color: .black.opacity(0.2), radius: 5)
                .accessibilityLabel("Add new container")

                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                        .shadow(color: .green, radius: 3)
                    Text("Docker Running")
                        .font(.subheadline)
                }
                .padding(.leading, 20)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Docker engine is running")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .frame(height: 55)
        .background(.thickMaterial)
    }
}

struct ToolbarButton: View {
    let systemImage: String
    let tooltip: String
    let accessibilityLabel: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.title3)
        }
        .buttonStyle(.borderless)
        .padding(8)
        .contentShape(Rectangle())
        .help(tooltip)
        .accessibilityLabel(accessibilityLabel)
    }
}

struct ToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView()
            .environmentObject(ContainerViewModel(containerService: MockContainerService()))
    }
}
