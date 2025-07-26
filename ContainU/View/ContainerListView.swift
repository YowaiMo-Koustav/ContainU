import SwiftUI

struct ContainerListView: View {
    @EnvironmentObject var viewModel: ContainerViewModel
    @Namespace private var namespace

    var body: some View {
        ZStack {
            if viewModel.viewMode == .list {
                ListView(namespace: namespace)
            } else {
                GridView(namespace: namespace)
            }
        }
        .background(Material.ultraThin)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: viewModel.viewMode)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.visibleContainers)
    }
}

private struct ListView: View {
    @EnvironmentObject var viewModel: ContainerViewModel
    var namespace: Namespace.ID

    var body: some View {
        List(selection: $viewModel.selectedContainerId) {
            ForEach(viewModel.visibleContainers) { container in
                ContainerRowView(container: container, namespace: namespace)
                    .tag(container.id)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .background(.clear)
    }
}

private struct GridView: View {
    @EnvironmentObject var viewModel: ContainerViewModel
    var namespace: Namespace.ID

    private let columns = [GridItem(.adaptive(minimum: 260), spacing: 20)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.visibleContainers) { container in
                    ContainerCardView(container: container, namespace: namespace) {
                        viewModel.selectContainer(id: container.id)
                    }
                }
            }
            .padding()
        }
    }
}

struct ContainerRowView: View {
    @EnvironmentObject var viewModel: ContainerViewModel
    let container: Container
    var namespace: Namespace.ID
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: container.status.icon)
                .font(.title2)
                .foregroundColor(container.status.color)
                .frame(width: 25, height: 25)
                .matchedGeometryEffect(id: "container.icon.\(container.id)", in: namespace)

            VStack(alignment: .leading) {
                Text(container.name)
                    .fontWeight(.medium)
                    .matchedGeometryEffect(id: "container.name.\(container.id)", in: namespace)
                Text(container.image)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .matchedGeometryEffect(id: "container.image.\(container.id)", in: namespace)
            }

            Spacer()

            Text(container.uptime)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            StatusPill(status: container.status)
                .matchedGeometryEffect(id: "container.status.\(container.id)", in: namespace)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            ZStack {
                if viewModel.selectedContainerId == container.id {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.accentColor.opacity(0.6))
                        .matchedGeometryEffect(id: "container.selection", in: namespace, properties: .frame)
                } else if isHovered {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.primary.opacity(0.15))
                }
            }
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.1)) { isHovered = hovering }
        }
        .contextMenu {
            Button { Task { await viewModel.startContainer(id: container.id) } } label: { Label("Start", systemImage: "play.fill") }.accessibilityLabel("Start container \(container.name)")
            Button { Task { await viewModel.stopContainer(id: container.id) } } label: { Label("Stop", systemImage: "stop.fill") }.accessibilityLabel("Stop container \(container.name)")
            Button { Task { await viewModel.restartContainer(id: container.id) } } label: { Label("Restart", systemImage: "arrow.clockwise") }.accessibilityLabel("Restart container \(container.name)")
            Divider()
            Button(role: .destructive) { Task { await viewModel.deleteContainer(id: container.id) } } label: { Label("Delete", systemImage: "trash") }.accessibilityLabel("Delete container \(container.name)")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(container.name), image \(container.image), status \(container.status.rawValue), uptime \(container.uptime)")
        .accessibilityHint("Double-tap to view details.")
    }
}

struct StatusPill: View {
    let status: ContainerStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.2))
            .foregroundColor(status.color)
            .clipShape(Capsule())
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Status: \(status.rawValue)")
    }
}

struct ContainerListView_Previews: PreviewProvider {
    static var previews: some View {
        let service = MockContainerService()
        let viewModel = ContainerViewModel(containerService: service)
        
        return Group {
            ContainerListView()
                .environmentObject(viewModel)
                .onAppear { viewModel.viewMode = .list }
                .previewDisplayName("List View")
            
            ContainerListView()
                .environmentObject(viewModel)
                .onAppear { viewModel.viewMode = .grid }
                .previewDisplayName("Grid View")
        }
        .frame(width: 800, height: 600)
    }
}
