import Foundation

struct MockData {
    static let networks: [Network] = [
        Network(name: "bridge", driver: "bridge", subnet: "172.18.0.0/16", scope: "local", attachable: true, internal: false),
        Network(name: "host", driver: "host", subnet: "", scope: "local", attachable: false, internal: false),
        Network(name: "none", driver: "null", subnet: "", scope: "local", attachable: false, internal: true),
        Network(name: "ingress", driver: "overlay", subnet: "10.0.0.0/24", scope: "swarm", attachable: true, internal: false),
        Network(name: "my-app-net", driver: "bridge", subnet: "172.19.0.0/16", scope: "local", attachable: true, internal: false)
    ]

    static let images: [ContainerImage] = [
        ContainerImage(repository: "nginx", tag: "latest", size: "125 MB", created: "2 days ago"),
        ContainerImage(repository: "postgres", tag: "14", size: "300 MB", created: "5 days ago"),
        ContainerImage(repository: "redis", tag: "6", size: "45 MB", created: "12 hours ago"),
        ContainerImage(repository: "ubuntu", tag: "22.04", size: "72 MB", created: "1 week ago"),
        ContainerImage(repository: "prometheus", tag: "latest", size: "155 MB", created: "20 hours ago")
    ]

    static let volumes: [Volume] = [
        Volume(name: "postgres-data", driver: "local", size: "2.5 GB", mountPoint: "/var/lib/postgresql/data"),
        Volume(name: "wordpress-content", driver: "local", size: "5.1 GB", mountPoint: "/var/www/html"),
        Volume(name: "nextcloud-data", driver: "local", size: "15.0 GB", mountPoint: "/var/www/nextcloud"),
        Volume(name: "prometheus-storage", driver: "local", size: "8.2 GB", mountPoint: "/prometheus")
    ]

    static func generateLogs() -> [LogEntry] {
        var logs: [LogEntry] = []
        let messages: [(String, LogLevel)] = [
            ("Initializing application...", .info),
            ("Configuration loaded successfully.", .info),
            ("Connecting to database at 192.168.1.100.", .info),
            ("Warning: High memory usage detected.", .warning),
            ("Database connection established.", .info),
            ("User 'admin' logged in.", .info),
            ("Error: Failed to process request #1234.", .error),
            ("Retrying request #1234...", .warning),
            ("Request #1234 processed successfully on retry.", .info),
            ("Shutting down application.", .info)
        ]

        for i in 0..<50 {
            let message = messages.randomElement()!
            logs.append(LogEntry(timestamp: Date().addingTimeInterval(-Double(i * 5)), message: message.0, level: message.1))
        }
        return logs.sorted(by: { $0.timestamp < $1.timestamp })
    }

    static func generateMetricData() -> [MetricDataPoint] {
        var data: [MetricDataPoint] = []
        let now = Date()
        for i in 0..<60 {
            let date = now.addingTimeInterval(-Double(i * 60))
            let value = Double.random(in: 5...85)
            data.append(MetricDataPoint(date: date, value: value))
        }
        return data.sorted(by: { $0.date < $1.date })
    }

    /// Generates a timeline of ContainerStats for the past `minutes` interval.
    static func generateStats(minutes: Int = 30) -> [ContainerStats] {
        var stats: [ContainerStats] = []
        let now = Date()
        for i in 0..<minutes {
            let date = now.addingTimeInterval(-Double(i * 60))
            stats.append(ContainerStats(timestamp: date,
                                         cpu: Double.random(in: 0...100),
                                         memory: Double.random(in: 50...500),
                                         networkIO: Double.random(in: 0...25)))
        }
        return stats.sorted { $0.timestamp < $1.timestamp }
    }

    static let containers: [Container] = [
        Container(name: "web-server-prod", image: "nginx:latest", status: .running, uptime: "2 days", cpuUsage: 5.3, memoryUsage: "256 MB", ports: ["80:80", "443:443"], networks: ["bridge", "my-app-net"]),
        Container(name: "db-main", image: "postgres:14", status: .running, uptime: "5 days", cpuUsage: 12.1, memoryUsage: "1.2 GB", ports: ["5432:5432"], networks: ["my-app-net"]),
        Container(name: "api-gateway", image: "traefik:v2.5", status: .running, uptime: "1 day", cpuUsage: 2.5, memoryUsage: "128 MB", ports: ["80:80"], networks: ["bridge"]),
        Container(name: "redis-cache", image: "redis:6", status: .stopped, uptime: "N/A", cpuUsage: 0.0, memoryUsage: "0 MB", ports: ["6379:6379"], networks: ["my-app-net"]),
        Container(name: "worker-node-1", image: "ubuntu:20.04", status: .error, uptime: "3 hours", cpuUsage: 99.0, memoryUsage: "512 MB", ports: ["22:22"], networks: ["none"]),
        Container(name: "monitoring-stack", image: "prometheus:latest", status: .running, uptime: "12 hours", cpuUsage: 8.7, memoryUsage: "450 MB", ports: ["9090:9090"], networks: ["bridge"]),
        Container(name: "dev-environment", image: "ubuntu:22.04", status: .stopped, uptime: "N/A", cpuUsage: 0.0, memoryUsage: "0 MB", ports: [], networks: []),
        Container(name: "caching-layer", image: "memcached:1.6", status: .running, uptime: "3 days", cpuUsage: 1.8, memoryUsage: "64 MB", ports: ["11211:11211"], networks: [])
    ]
}
