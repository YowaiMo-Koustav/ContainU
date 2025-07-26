import SwiftUI

struct VolumeListView: View {
    @EnvironmentObject var viewModel: ContainerViewModel

    var body: some View {
        HSplitView {
            volumeList
                .frame(minWidth: 250, idealWidth: 300, maxWidth: 400)

            if let selectedVolumeId = viewModel.selectedVolumeId, let volume = viewModel.volumes.first(where: { $0.id == selectedVolumeId }) {
                VolumeDetailView(volume: volume)
                    .frame(maxWidth: .infinity)
            } else {
                VStack {
                    Text("No Volume Selected")
                        .font(.title)
                        .foregroundColor(.secondary)
                    Text("Please select a volume from the list.")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Material.ultraThin)
        .navigationTitle("Volumes")
    }

    private var volumeList: some View {
        List(selection: $viewModel.selectedVolumeId) {
            ForEach(viewModel.volumes) { volume in
                VolumeRowView(volume: volume)
                    .tag(volume.id)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .background(.clear)
    }
}

struct VolumeRowView: View {
    let volume: Volume
    @EnvironmentObject var viewModel: ContainerViewModel
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "externaldrive.fill")
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 25)

            VStack(alignment: .leading) {
                Text(volume.name).fontWeight(.medium)
                Text("Driver: \(volume.driver)").font(.caption).foregroundColor(.secondary)
            }

            Spacer()

            Text(volume.size)
                .font(.caption.monospaced())
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.primary.opacity(0.1))
                .clipShape(Capsule())
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(viewModel.selectedVolumeId == volume.id ? Color.accentColor.opacity(0.6) : isHovered ? .primary.opacity(0.15) : .clear)
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.1)) { isHovered = hovering }
        }
        .contextMenu {
            Button(role: .destructive) { Task { await viewModel.removeVolume(id: volume.id) } } label: { Label("Remove Volume", systemImage: "trash") }
                .accessibilityLabel("Remove volume \(volume.name)")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Volume \(volume.name), driver \(volume.driver), size \(volume.size)")
        .accessibilityHint("Selects the volume and shows details.")
    }
}

struct VolumeDetailView: View {
    let volume: Volume

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text(volume.name)
                    .font(.title.bold())
                Text(volume.id.uuidString)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
                    .textSelection(.enabled)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Volume name: \(volume.name). ID: \(volume.id)")

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                InfoRow(label: "Driver", value: volume.driver)
                InfoRow(label: "Mount Point", value: volume.mountPoint)
                InfoRow(label: "Size", value: volume.size)
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Volume Details")

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Material.thick, in: RoundedRectangle(cornerRadius: 12))
        .padding()
    }
}

struct VolumeListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ContainerViewModel(containerService: MockContainerService())
        viewModel.selectedVolumeId = viewModel.volumes.first?.id

        return VolumeListView()
            .environmentObject(viewModel)
            .frame(width: 800, height: 500)
    }
}
