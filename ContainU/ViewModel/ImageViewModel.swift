import Foundation
import SwiftUI
import Combine

/// Manages the list of available container images and simple search/filter options.
@MainActor
class ImageViewModel: ObservableObject {
    // MARK: - Service Dependencies
    #if FAKE_BACKEND
    @EnvironmentObject var containerService: MockContainerService
    #else
    @EnvironmentObject var containerService: ContainerService
    #endif
    
    @Published var images: [ContainerImage] = []
    @Published var searchText: String = "" {
        didSet { applyFilters() }
    }
    @Published private(set) var filteredImages: [ContainerImage] = []

    init() {
        loadImages()
        applyFilters()
    }

    // MARK: - Data Loading
    
    private func loadImages() {
        #if FAKE_BACKEND
        images = FakeData.containerImages
        #else
        Task {
            do {
                images = try await containerService.listImages()
            } catch {
                print("Failed to load images: \(error)")
            }
        }
        #endif
    }
    
    // MARK: - Image Management
    
    func pullImage(repository: String, tag: String = "latest") async {
        #if FAKE_BACKEND
        do {
            _ = try await containerService.pullImage(repository: repository, tag: tag)
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.3)) {
                    images = containerService.images
                    applyFilters()
                }
            }
        } catch {
            print("Failed to pull image: \(error)")
        }
        #else
        // Real implementation would go here
        #endif
    }
    
    func removeImage(_ image: ContainerImage) async {
        #if FAKE_BACKEND
        do {
            try await containerService.removeImage(image)
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.3)) {
                    images = containerService.images
                    applyFilters()
                }
            }
        } catch {
            print("Failed to remove image: \(error)")
        }
        #else
        // Real implementation would go here
        #endif
    }
    
    private func applyFilters() {
        if searchText.isEmpty {
            filteredImages = images
        } else {
            let lower = searchText.lowercased()
            filteredImages = images.filter { $0.repository.lowercased().contains(lower) || $0.tag.lowercased().contains(lower) }
        }
    }
}
