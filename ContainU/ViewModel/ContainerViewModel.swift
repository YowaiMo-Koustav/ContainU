import Foundation
import SwiftUI
import Combine

@MainActor
enum ViewMode {
    case list, grid
}

class ContainerViewModel: ObservableObject {
    // MARK: - Service Dependencies
    #if FAKE_BACKEND
    private let containerService: MockContainerService
    #else
    private let containerService: ContainerService
    #endif

    // MARK: - Published State Properties

    // Resource data from service
    @Published var containers: [Container] = []
    @Published var networks: [Network] = []
    @Published var volumes: [Volume] = []
    @Published var images: [ContainerImage] = []

    // Navigation & View State
    @Published var selectedCategory: NavigationCategory? = .containers
    @Published var searchQuery: String = ""
    @Published var sortOption: ContainerSortOption = .name
    @Published var viewMode: ViewMode = .list
    @Published var isShowingCreateSheet: Bool = false

    // Selection State
    @Published var selectedContainerId: UUID? = nil
    @Published var selectedContainers: Set<Container.ID> = []
    @Published var selectedImageId: UUID? = nil
    @Published var selectedNetworkId: UUID? = nil
    @Published var selectedVolumeId: UUID? = nil

    // MARK: - Computed Properties

    var selectedContainer: Container? {
        guard let selectedId = selectedContainerId else { return nil }
        return containers.first { $0.id == selectedId }
    }

    var selectedNetwork: Network? {
        guard let selectedNetworkId = selectedNetworkId else { return nil }
        return self.networks.first { $0.id == selectedNetworkId }
    }

    var selectedVolume: Volume? {
        guard let selectedVolumeId = selectedVolumeId else { return nil }
        return self.volumes.first { $0.id == selectedVolumeId }
    }

    var visibleContainers: [Container] {
        var result: [Container]
        if searchQuery.isEmpty {
            result = containers
        } else {
            let lower = searchQuery.lowercased()
            result = containers.filter { $0.name.lowercased().contains(lower) || $0.image.lowercased().contains(lower) }
        }
        switch sortOption {
        case .name:
            result.sort { $0.name.lowercased() < $1.name.lowercased() }
        case .status:
            result.sort { $0.status.rawValue < $1.status.rawValue }
        case .uptime:
            result.sort { $0.uptime < $1.uptime }
        }
        return result
    }

    // MARK: - Initialization
    #if FAKE_BACKEND
    init(containerService: MockContainerService) {
        self.containerService = containerService
        self.containers = containerService.containers
        self.networks = containerService.networks
        self.volumes = containerService.volumes
        self.images = containerService.images
        
        if let firstContainer = containerService.containers.first {
            self.selectedContainerId = firstContainer.id
        }
    }
    #else
    init(containerService: ContainerService) {
        self.containerService = containerService
        // In a real app, you would fetch data here.
    }
    #endif

    // MARK: - UI Triggers
    func showCreateSheet() {
        isShowingCreateSheet = true
    }
    
    func selectContainer(id: UUID?) {
        selectedContainerId = id
    }

    // MARK: - Consolidated Actions
    func startSelectedOrCurrent() async {
        let ids = selectedContainers.isEmpty ? (selectedContainerId.map { [$0] } ?? []) : Array(selectedContainers)
        guard !ids.isEmpty else { return }
        await withTaskGroup(of: Void.self) {
            group in
            for id in ids {
                group.addTask { await self.startContainer(id: id) }
            }
        }
    }

    func stopSelectedOrCurrent() async {
        let ids = selectedContainers.isEmpty ? (selectedContainerId.map { [$0] } ?? []) : Array(selectedContainers)
        guard !ids.isEmpty else { return }
        await withTaskGroup(of: Void.self) {
            group in
            for id in ids {
                group.addTask { await self.stopContainer(id: id) }
            }
        }
    }

    func restartSelectedOrCurrent() async {
        let ids = selectedContainers.isEmpty ? (selectedContainerId.map { [$0] } ?? []) : Array(selectedContainers)
        guard !ids.isEmpty else { return }
        await withTaskGroup(of: Void.self) {
            group in
            for id in ids {
                group.addTask { await self.restartContainer(id: id) }
            }
        }
    }

    /// Deletes the selected containers or the currently selected container by their UUID(s).
    /// - Parameter id: The UUID of the container to delete.
    func deleteSelectedOrCurrent() async {
        let ids = selectedContainers.isEmpty ? (selectedContainerId.map { [$0] } ?? []) : Array(selectedContainers)
        guard !ids.isEmpty else { return }
        await withTaskGroup(of: Void.self) {
            group in
            for id in ids {
                group.addTask { await self.deleteContainer(id: id) }
            }
        }
    }

    /// Deletes a container by its UUID.
    /// - Parameter id: The UUID of the container to delete.
    func deleteContainer(id: UUID) async {
        #if FAKE_BACKEND
        guard let container = containerService.containers.first(where: { $0.id == id }) else { return }
        do {
            try await containerService.removeContainer(container)
            await MainActor.run {
                if self.selectedContainerId == id {
                    self.selectedContainerId = nil
                }
                self.selectedContainers.remove(id)
            }
            await refreshData()
        } catch {
            print("Failed to delete container: \(error)")
        }
        #endif
    }

    // MARK: - Individual Container Actions
    func startContainer(id: UUID) async {
        #if FAKE_BACKEND
        guard let container = containerService.containers.first(where: { $0.id == id }) else { return }
        do {
            try await containerService.startContainer(container)
            await refreshData()
        } catch {
            print("Failed to start container: \(error)")
        }
        #endif
    }

    func stopContainer(id: UUID) async {
        #if FAKE_BACKEND
        guard let container = containerService.containers.first(where: { $0.id == id }) else { return }
        do {
            try await containerService.stopContainer(container)
            await refreshData()
        } catch {
            print("Failed to stop container: \(error)")
        }
        #endif
    }

    func restartContainer(id: UUID) async {
        #if FAKE_BACKEND
        guard let container = containerService.containers.first(where: { $0.id == id }) else { return }
        do {
            try await containerService.stopContainer(container)
            try await Task.sleep(nanoseconds: 500_000_000)
            try await containerService.startContainer(container)
            await refreshData()
        } catch {
            print("Failed to restart container: \(error)")
        }
        #endif
    }

    func createContainer(name: String, image: String, networks: [String] = [], volumes: [String] = [], ports: [String] = []) async {
        #if FAKE_BACKEND
        do {
            let _ = try await containerService.createContainer(name: name, image: image, ports: ports, networks: networks, volumes: volumes)
            await refreshData()
            await MainActor.run {
                if let newContainer = containerService.containers.first(where: { $0.name == name }) {
                    self.selectedContainerId = newContainer.id
                }
            }
        } catch {
            print("Failed to create container: \(error)")
        }
        #endif
    }

    // MARK: - Image Management
    func pullImage(name: String) async {
        #if FAKE_BACKEND
        do {
            let _ = try await containerService.pullImage(repository: name, tag: "latest")
            await refreshData()
        } catch {
            print("Failed to pull image: \(error)")
        }
        #endif
    }

    func removeImage(_ image: ContainerImage) async {
        #if FAKE_BACKEND
        do {
            try await containerService.removeImage(image)
            await refreshData()
        } catch {
            print("Failed to remove image: \(error)")
        }
        #endif
    }

    // MARK: - Network Management

    /// Creates a new network with the specified name and driver.
    /// - Parameters:
    ///   - name: The name of the network to create.
    ///   - driver: The driver to use for the network. Defaults to "bridge".
    func createNetwork(name: String, driver: String = "bridge") async {
        #if FAKE_BACKEND
        do {
            let _ = try await containerService.createNetwork(name: name, driver: driver)
            await refreshData()
        } catch {
            print("Failed to create network: \(error)")
        }
        #endif
    }

    /// Removes the specified network.
    /// - Parameter network: The `Network` object to remove.
    func removeNetwork(_ network: Network) async {
        #if FAKE_BACKEND
        do {
            try await containerService.removeNetwork(network)
            await refreshData()
        } catch {
            print("Failed to remove network: \(error)")
        }
        #endif
    }
    
    @MainActor
    func fetchNetworks() async {
        do {
            self.networks = try await containerService.listNetworks()
        } catch {
            print("Failed to fetch networks: \(error)")
            self.networks = []
        }
    }

    // MARK: - Volume Management

    /// Creates a new volume with the specified name and driver.
    /// - Parameters:
    ///   - name: The name of the volume to create.
    ///   - driver: The driver to use for the volume. Defaults to "local".
    func createVolume(name: String, driver: String = "local") async {
        #if FAKE_BACKEND
        do {
            let _ = try await containerService.createVolume(name: name, driver: driver)
            await refreshData()
        } catch {
            print("Failed to create volume: \(error)")
        }
        #endif
    }

    /// Removes the specified volume.
    /// - Parameter volume: The `Volume` object to remove.
    func removeVolume(_ volume: Volume) async {
        #if FAKE_BACKEND
        do {
            try await containerService.removeVolume(volume)
            await refreshData()
        } catch {
            print("Failed to remove volume: \(error)")
        }
        #endif
    }

    /// Removes a volume by its UUID.
    /// - Parameter id: The UUID of the volume to remove.
    func removeVolume(id: UUID) async {
        #if FAKE_BACKEND
        guard let volume = volumes.first(where: { $0.id == id }) else { return }
        await removeVolume(volume)
        #endif
    }

    // MARK: - Log Management
    func fetchLogs(for container: Container) async -> [LogEntry] {
        #if FAKE_BACKEND
        return (try? await containerService.fetchLogs(for: container)) ?? []
        #else
        return []
        #endif
    }

    // MARK: - Shell Execution
    func executeShell(in container: Container, command: String) async -> String {
        #if FAKE_BACKEND
        return (try? await containerService.executeShell(in: container, command: command)) ?? "Error: Command failed"
        #else
        return "Command executed"
        #endif
    }
    
    // MARK: - Private Helpers
    private func refreshData() async {
        await MainActor.run {
            withAnimation(.easeInOut(duration: 0.3)) {
                self.containers = containerService.containers
                self.images = containerService.images
                self.networks = containerService.networks
                self.volumes = containerService.volumes
            }
        }
    }
}
