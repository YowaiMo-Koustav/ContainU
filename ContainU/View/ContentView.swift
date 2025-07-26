import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ContainerViewModel
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic

    #if FAKE_BACKEND
    init(containerService: MockContainerService) {
        _viewModel = StateObject(wrappedValue: ContainerViewModel(containerService: containerService))
    }
    #else
    init(containerService: ContainerService) {
        _viewModel = StateObject(wrappedValue: ContainerViewModel(containerService: containerService))
    }
    #endif

    var body: some View {
        VStack(spacing: 0) {
            ToolbarView()
            
            NavigationSplitView(columnVisibility: $columnVisibility) {
                SidebarView()
            } content: {
                Group {
                    switch viewModel.selectedCategory {
                    case .containers, .none:
                        ContainerListView()
                    case .images:
                        ImageListView()
                    case .networks:
                        NetworkListView()
                    case .volumes:
                        VolumeListView()
                    case .topology:
                        NetworkTopologyView()
                    }
                }
                .id(viewModel.selectedCategory)
                .animation(.easeInOut(duration: 0.3), value: viewModel.selectedCategory)
            } detail: {
                if viewModel.selectedCategory == .containers {
                    ContainerDetailView()
                } else {
                    Text("Select an item to view details")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .background(.ultraThinMaterial)
        .environmentObject(viewModel)
        .sheet(isPresented: $viewModel.isShowingCreateSheet) {
            CreateContainerWizardView()
                .environmentObject(viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(containerService: MockContainerService())
    }
}
