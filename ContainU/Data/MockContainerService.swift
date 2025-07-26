//
//  MockContainerService.swift
//  ContainU
//
//  Created by KOUSTAV MALLICK on 26/07/25.
//

import Foundation
import SwiftUI
import Combine

#if FAKE_BACKEND

/// Mock implementation of Containerization framework APIs with in-memory state and async stubs
@MainActor
class MockContainerService: ObservableObject {
    
    // MARK: - In-Memory State
    @Published var containers: [Container] = MockData.containers
    @Published var images: [ContainerImage] = MockData.images
    @Published var networks: [Network] = MockData.networks
    @Published var volumes: [Volume] = MockData.volumes
    @Published var logs: [String: [LogEntry]] = [:]
    
    // MARK: - Container Management APIs
    
    /// Creates a new container from the specified image
    func createContainer(name: String, image: String, ports: [String] = [], networks: [String] = [], volumes: [String] = []) async throws -> Container {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        
        let newContainer = Container(
            name: name,
            image: image,
            status: .stopped,
            uptime: "N/A",
            cpuUsage: 0.0,
            memoryUsage: "0 MB",
            ports: ports,
            networks: networks,
            volumes: volumes
        )
        
        containers.append(newContainer)
        logs[newContainer.id.uuidString] = []
        
        return newContainer
    }
    
    /// Starts a container
    func startContainer(_ container: Container) async throws {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        
        if let index = containers.firstIndex(where: { $0.id == container.id }) {
            containers[index].status = .running
            containers[index].uptime = "Just now"
            containers[index].cpuUsage = Double.random(in: 1...15)
            containers[index].memoryUsage = "\(Int.random(in: 64...512)) MB"
            
            // Add startup log entries
            let startupLogs = [
                LogEntry(timestamp: Date(), message: "Container \(container.name) starting...", level: .info),
                LogEntry(timestamp: Date().addingTimeInterval(1), message: "Container \(container.name) started successfully", level: .info)
            ]
            logs[container.id.uuidString, default: []].append(contentsOf: startupLogs)
        }
    }
    
    /// Stops a container
    func stopContainer(_ container: Container) async throws {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        
        if let index = containers.firstIndex(where: { $0.id == container.id }) {
            containers[index].status = .stopped
            containers[index].uptime = "N/A"
            containers[index].cpuUsage = 0.0
            containers[index].memoryUsage = "0 MB"
            
            // Add shutdown log entries
            let shutdownLogs = [
                LogEntry(timestamp: Date(), message: "Container \(container.name) stopping...", level: .info),
                LogEntry(timestamp: Date().addingTimeInterval(1), message: "Container \(container.name) stopped", level: .info)
            ]
            logs[container.id.uuidString, default: []].append(contentsOf: shutdownLogs)
        }
    }
    
    /// Removes a container
    func removeContainer(_ container: Container) async throws {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        
        containers.removeAll { $0.id == container.id }
        logs.removeValue(forKey: container.id.uuidString)
    }
    
    /// Restarts a container
    func restartContainer(_ container: Container) async throws {
        try await stopContainer(container)
        try await Task.sleep(nanoseconds: 200_000_000)
        try await startContainer(container)
    }
    
    // MARK: - Image Management APIs
    
    /// Lists all available images
    func listImages() async throws -> [ContainerImage] {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        return images
    }
    
    /// Pulls an image from a registry
    func pullImage(repository: String, tag: String = "latest") async throws -> ContainerImage {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        
        let newImage = ContainerImage(
            repository: repository,
            tag: tag,
            size: "\(Int.random(in: 50...500)) MB",
            created: "Just now"
        )
        
        images.append(newImage)
        return newImage
    }
    
    /// Removes an image
    func removeImage(_ image: ContainerImage) async throws {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        
        images.removeAll { $0.id == image.id }
    }
    
    // MARK: - Log Management APIs
    
    /// Fetches logs for a specific container
    func fetchLogs(for container: Container, tail: Int = 100) async throws -> [LogEntry] {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        
        let containerLogs = logs[container.id.uuidString] ?? MockData.generateLogs()
        logs[container.id.uuidString] = containerLogs
        
        return Array(containerLogs.suffix(tail))
    }
    
    /// Streams logs for a container (simulated with periodic updates)
    func streamLogs(for container: Container) -> AsyncStream<LogEntry> {
        return AsyncStream { continuation in
            Task {
                let messages = [
                    "Application started successfully",
                    "Processing request from 192.168.1.100",
                    "Database connection established",
                    "Cache hit for key: user_session_123",
                    "Request completed in 45ms",
                    "Memory usage: 234MB",
                    "CPU usage: 12.5%"
                ]
                
                for _ in 0..<20 {
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                    let message = messages.randomElement()!
                    let logEntry = LogEntry(
                        timestamp: Date(),
                        message: message,
                        level: .info
                    )
                    continuation.yield(logEntry)
                    
                    // Add to stored logs
                    logs[container.id.uuidString, default: []].append(logEntry)
                }
                continuation.finish()
            }
        }
    }
    
    // MARK: - Shell Execution APIs
    
    /// Executes a shell command in a container
    func executeShell(in container: Container, command: String) async throws -> String {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        
        // Return canned responses based on common commands
        switch command.lowercased() {
        case "ls", "ls -la":
            return """
            total 64
            drwxr-xr-x  1 root root  4096 Jul 26 12:00 .
            drwxr-xr-x  1 root root  4096 Jul 26 12:00 ..
            -rw-r--r--  1 root root   220 Jul 26 12:00 .bashrc
            -rw-r--r--  1 root root  3771 Jul 26 12:00 .profile
            drwxr-xr-x  2 root root  4096 Jul 26 12:00 app
            drwxr-xr-x  2 root root  4096 Jul 26 12:00 bin
            drwxr-xr-x  2 root root  4096 Jul 26 12:00 etc
            """
        case "pwd":
            return "/app"
        case "whoami":
            return "root"
        case "ps aux", "ps":
            return """
            USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
            root         1  0.0  0.1   4624  1024 ?        Ss   12:00   0:00 /bin/bash
            root        42  0.2  0.5  12345  5678 ?        S    12:01   0:00 app
            """
        case let cmd where cmd.contains("cat"):
            return "File contents would appear here..."
        case let cmd where cmd.contains("echo"):
            let echoText = command.replacingOccurrences(of: "echo ", with: "")
            return echoText.replacingOccurrences(of: "\"", with: "")
        default:
            return "Command '\(command)' executed successfully"
        }
    }
    
    // MARK: - Network Management APIs
    
    /// Lists all networks
    func listNetworks() async throws -> [Network] {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        return networks
    }
    
    /// Creates a new network
    func createNetwork(name: String, driver: String = "bridge") async throws -> Network {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        
        let newNetwork = Network(
            name: name,
            driver: driver,
            subnet: "172.\(Int.random(in: 20...30)).0.0/16",
            scope: "local",
            attachable: true,
            internal: false
        )
        
        networks.append(newNetwork)
        return newNetwork
    }
    
    /// Removes a network
    func removeNetwork(_ network: Network) async throws {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        
        networks.removeAll { $0.id == network.id }
    }
    
    // MARK: - Volume Management APIs
    
    /// Lists all volumes
    func listVolumes() async throws -> [Volume] {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        return volumes
    }
    
    /// Creates a new volume
    func createVolume(name: String, driver: String = "local") async throws -> Volume {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        
        let newVolume = Volume(
            name: name,
            driver: driver,
            size: "0 B",
            mountPoint: "/var/lib/docker/volumes/\(name)/_data"
        )
        
        volumes.append(newVolume)
        return newVolume
    }
    
    /// Removes a volume
    func removeVolume(_ volume: Volume) async throws {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        
        volumes.removeAll { $0.id == volume.id }
    }
    
    // MARK: - Container Stats APIs
    
    /// Gets real-time stats for a container
    func getContainerStats(for container: Container) async throws -> ContainerStats {
        // Simulate network latency
        try await Task.sleep(nanoseconds: 200_000_000)
        
        return ContainerStats(
            timestamp: Date(),
            cpu: Double.random(in: 0...100),
            memory: Double.random(in: 50...500),
            networkIO: Double.random(in: 0...25)
        )
    }
    
    /// Streams real-time stats for a container
    func streamContainerStats(for container: Container) -> AsyncStream<ContainerStats> {
        return AsyncStream { continuation in
            Task {
                for _ in 0..<60 {
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
                    let stats = ContainerStats(
                        timestamp: Date(),
                        cpu: Double.random(in: 0...100),
                        memory: Double.random(in: 50...500),
                        networkIO: Double.random(in: 0...25)
                    )
                    continuation.yield(stats)
                }
                continuation.finish()
            }
        }
    }
}

#else

// MARK: - Real Containerization Framework Implementation
// This would contain the actual Containerization framework calls
// when FAKE_BACKEND is not defined

import Containerization

@MainActor
class ContainerService: ObservableObject {
    // Real implementation would go here using actual Containerization APIs
    // For now, this is a placeholder that would use the real framework
}

#endif
