import SwiftUI

struct ImageListView: View {
    @EnvironmentObject var viewModel: ContainerViewModel

    var body: some View {
        HSplitView {
            List(selection: $viewModel.selectedImageId) {
                ForEach(viewModel.images) { image in
                    ImageRowView(image: image)
                        .tag(image.id)
                }
            }
            .listStyle(.plain)
            .background(Material.ultraThin)
            .frame(minWidth: 300)

            if let selectedImageId = viewModel.selectedImageId,
               let image = viewModel.images.first(where: { $0.id == selectedImageId }) {
                ImageDetailView(image: image)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("Select an Image")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Material.ultraThin)
            }
        }
        .navigationTitle("Images")
    }
}

private struct ImageRowView: View {
    let image: ContainerImage
    @EnvironmentObject var viewModel: ContainerViewModel
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(image.fullName)
                    .fontWeight(.medium)
                    .lineLimit(1)
                Text("Created: \(image.created)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(image.size)
                .font(.system(.caption, design: .monospaced))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.primary.opacity(0.1))
                .clipShape(Capsule())
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Material.thick, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .opacity(isHovered || viewModel.selectedImageId == image.id ? 1.0 : 0.8)
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .onHover { hovering in
            withAnimation(.spring()) {
                isHovered = hovering
            }
        }
        .contextMenu {
            Button(action: { Task { await viewModel.pullImage(name: image.fullName) } }) {
                Label("Pull Latest", systemImage: "arrow.down.circle")
            }
            .accessibilityLabel("Pull latest version of image \(image.fullName)")
            Button(role: .destructive, action: { Task { await viewModel.removeImage(image) } }) {
                Label("Remove Image", systemImage: "trash")
            }
            .accessibilityLabel("Remove image \(image.fullName)")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(image.fullName), size \(image.size), created \(image.created)")
        .accessibilityHint("Selects the image and shows details.")
    }
}

struct ImageDetailView: View {
    let image: ContainerImage

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 48))
                    .foregroundColor(.accentColor)
                Text(image.fullName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Image: \(image.fullName)")
            
            VStack(alignment: .leading, spacing: 12) {
                InfoRow(label: "Image ID", value: image.id.uuidString)
                InfoRow(label: "Tag", value: image.tag)
                InfoRow(label: "Size", value: image.size)
                InfoRow(label: "Created", value: image.created)
            }
            .padding()
            .background(Material.thick, in: RoundedRectangle(cornerRadius: 12))
            
            Spacer()
        }
        .padding(30)
        .background(.ultraThinMaterial)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Image Details")
    }
}


struct ImageListView_Previews: PreviewProvider {
    static var previews: some View {
        let service = MockContainerService()
        let viewModel = ContainerViewModel(containerService: service)
        viewModel.selectedImageId = service.images.first?.id
        
        return ImageListView()
            .environmentObject(viewModel)
    }
}
