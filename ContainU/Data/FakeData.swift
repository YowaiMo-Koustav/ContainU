//
//  FakeData.swift
//  ContainU
//
//  Created by KOUSTAV MALLICK on 26/07/25.
//

import Foundation
import SwiftUI

/// Comprehensive fake data arrays for demo use, as specified in workspace rules
struct FakeData {
    
    // MARK: - Container Images
    
    static let containerImages: [ContainerImage] = [
        // Popular Web Servers
        ContainerImage(repository: "nginx", tag: "latest", size: "125 MB", created: "2 days ago"),
        ContainerImage(repository: "nginx", tag: "alpine", size: "23 MB", created: "1 week ago"),
        ContainerImage(repository: "apache", tag: "2.4", size: "145 MB", created: "3 days ago"),
        ContainerImage(repository: "httpd", tag: "alpine", size: "56 MB", created: "5 days ago"),
        
        // Databases
        ContainerImage(repository: "postgres", tag: "14", size: "300 MB", created: "5 days ago"),
        ContainerImage(repository: "postgres", tag: "15", size: "315 MB", created: "1 day ago"),
        ContainerImage(repository: "mysql", tag: "8.0", size: "450 MB", created: "1 week ago"),
        ContainerImage(repository: "redis", tag: "6", size: "45 MB", created: "12 hours ago"),
        ContainerImage(repository: "mongodb", tag: "6.0", size: "680 MB", created: "4 days ago"),
        
        // Programming Languages & Runtimes
        ContainerImage(repository: "node", tag: "18", size: "350 MB", created: "1 day ago"),
        ContainerImage(repository: "python", tag: "3.11", size: "380 MB", created: "3 days ago"),
        ContainerImage(repository: "openjdk", tag: "17", size: "470 MB", created: "1 week ago"),
        ContainerImage(repository: "golang", tag: "1.19", size: "280 MB", created: "4 days ago"),
        
        // Operating Systems
        ContainerImage(repository: "ubuntu", tag: "22.04", size: "72 MB", created: "1 week ago"),
        ContainerImage(repository: "alpine", tag: "latest", size: "5.6 MB", created: "3 days ago"),
        ContainerImage(repository: "debian", tag: "bullseye", size: "80 MB", created: "1 week ago"),
        
        // Monitoring & Tools
        ContainerImage(repository: "prometheus", tag: "latest", size: "155 MB", created: "20 hours ago"),
        ContainerImage(repository: "grafana", tag: "9.3.0", size: "280 MB", created: "1 week ago"),
        ContainerImage(repository: "traefik", tag: "v2.9", size: "85 MB", created: "3 days ago")
    ]
    
    // MARK: - Containers
    
    static let containers: [Container] = [
        Container(name: "web-server-prod", image: "nginx:latest", status: .running, uptime: "2 days", cpuUsage: 5.3, memoryUsage: "256 MB", ports: ["80:80", "443:443"], networks: ["bridge", "my-app-net"]),
        Container(name: "db-main", image: "postgres:14", status: .running, uptime: "5 days", cpuUsage: 12.1, memoryUsage: "1.2 GB", ports: ["5432:5432"], networks: ["my-app-net"]),
        Container(name: "api-gateway", image: "traefik:v2.9", status: .running, uptime: "1 day", cpuUsage: 2.5, memoryUsage: "128 MB", ports: ["80:80"], networks: ["bridge"]),
        Container(name: "redis-cache", image: "redis:6", status: .stopped, uptime: "N/A", cpuUsage: 0.0, memoryUsage: "0 MB", ports: ["6379:6379"], networks: ["my-app-net"]),
        Container(name: "worker-node-1", image: "ubuntu:20.04", status: .error, uptime: "3 hours", cpuUsage: 99.0, memoryUsage: "512 MB", ports: ["22:22"], networks: ["none"]),
        Container(name: "monitoring-stack", image: "prometheus:latest", status: .running, uptime: "12 hours", cpuUsage: 8.7, memoryUsage: "450 MB", ports: ["9090:9090"], networks: ["bridge"]),
        Container(name: "dev-environment", image: "ubuntu:22.04", status: .stopped, uptime: "N/A", cpuUsage: 0.0, memoryUsage: "0 MB", ports: [], networks: []),
        Container(name: "caching-layer", image: "memcached:1.6", status: .running, uptime: "3 days", cpuUsage: 1.8, memoryUsage: "64 MB", ports: ["11211:11211"], networks: [])
    ]
    
    // MARK: - Networks
    
    static let networks: [Network] = [
        Network(name: "bridge", driver: "bridge", subnet: "172.17.0.0/16", scope: "local", attachable: true, internal: false),
        Network(name: "host", driver: "host", subnet: "", scope: "local", attachable: false, internal: false),
        Network(name: "none", driver: "null", subnet: "", scope: "local", attachable: false, internal: true),
        Network(name: "my-app-net", driver: "bridge", subnet: "172.19.0.0/16", scope: "local", attachable: true, internal: false),
        Network(name: "database-net", driver: "bridge", subnet: "172.20.0.0/16", scope: "local", attachable: true, internal: false),
        Network(name: "monitoring-net", driver: "bridge", subnet: "172.23.0.0/16", scope: "local", attachable: true, internal: false),
        Network(name: "ingress", driver: "overlay", subnet: "10.0.0.0/24", scope: "swarm", attachable: true, internal: false)
    ]
    
    // MARK: - Volumes
    
    static let volumes: [Volume] = [
        Volume(name: "postgres-data", driver: "local", size: "2.5 GB", mountPoint: "/var/lib/postgresql/data"),
        Volume(name: "wordpress-content", driver: "local", size: "5.1 GB", mountPoint: "/var/www/html"),
        Volume(name: "nextcloud-data", driver: "local", size: "15.0 GB", mountPoint: "/var/www/nextcloud"),
        Volume(name: "prometheus-storage", driver: "local", size: "8.2 GB", mountPoint: "/prometheus"),
        Volume(name: "app-logs", driver: "local", size: "1.2 GB", mountPoint: "/var/log/app"),
        Volume(name: "nginx-config", driver: "local", size: "45 MB", mountPoint: "/etc/nginx"),
        Volume(name: "backup-storage", driver: "local", size: "45.2 GB", mountPoint: "/backups")
    ]
    
    // MARK: - Log Messages
    
    static let logMessages: [(String, LogLevel)] = [
        ("Application starting up...", .info),
        ("Configuration loaded successfully", .info),
        ("Database connection established", .info),
        ("HTTP server started on port 8080", .info),
        ("User 'admin' logged in", .info),
        ("Processing request from 192.168.1.100", .info),
        ("Cache hit for key: user_session_123", .info),
        ("Request completed in 45ms", .info),
        ("Memory usage: 234MB", .info),
        ("CPU usage: 12.5%", .info),
        ("High memory usage detected", .warning),
        ("Database connection pool nearly exhausted", .warning),
        ("Slow query detected: took 2.5 seconds", .warning),
        ("SSL certificate expires in 30 days", .warning),
        ("Failed to process request #1234", .error),
        ("Database connection failed: timeout", .error),
        ("Authentication failed for user 'guest'", .error),
        ("Out of memory error", .error),
        ("Network timeout connecting to external service", .error),
        ("Graceful shutdown initiated", .info)
    ]
    
    // MARK: - Shell Command Outputs
    
    static let shellCommands: [String: String] = [
        "ls": """
        total 64
        drwxr-xr-x  1 root root  4096 Jul 26 12:00 .
        drwxr-xr-x  1 root root  4096 Jul 26 12:00 ..
        -rw-r--r--  1 root root   220 Jul 26 12:00 .bashrc
        drwxr-xr-x  2 root root  4096 Jul 26 12:00 app
        drwxr-xr-x  2 root root  4096 Jul 26 12:00 bin
        drwxr-xr-x  2 root root  4096 Jul 26 12:00 etc
        """,
        "pwd": "/app",
        "whoami": "root",
        "ps aux": """
        USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
        root         1  0.1  0.5  12345  5678 ?        Ss   12:00   0:01 /app/server
        root        42  0.0  0.2   4624  2048 ?        S    12:01   0:00 nginx: master
        www-data    43  0.0  0.1   4624  1024 ?        S    12:01   0:00 nginx: worker
        """,
        "uname -a": "Linux container-host 5.15.0-72-generic #79-Ubuntu x86_64 GNU/Linux",
        "hostname": "web-server-prod",
        "uptime": " 12:30:45 up 2 days,  3:45,  1 user,  load average: 0.15, 0.25, 0.30",
        "df -h": """
        Filesystem      Size  Used Avail Use% Mounted on
        overlay          59G  8.2G   48G  15% /
        tmpfs            64M     0   64M   0% /dev
        /dev/sda1        59G  8.2G   48G  15% /etc/hosts
        """,
        "date": "Wed Jul 26 12:30:45 UTC 2025",
        "help": "Available commands: ls, pwd, whoami, ps, uname, hostname, uptime, df, date"
    ]
    
    // MARK: - Helper Methods
    
    /// Generates random log entries for demo purposes
    static func generateRandomLogs(count: Int = 50) -> [LogEntry] {
        var logs: [LogEntry] = []
        
        for i in 0..<count {
            let message = logMessages.randomElement()!
            let timestamp = Date().addingTimeInterval(-Double(i * 30))
            logs.append(LogEntry(timestamp: timestamp, message: message.0, level: message.1))
        }
        
        return logs.sorted(by: { $0.timestamp < $1.timestamp })
    }
    
    /// Generates metric data points for demo charts
    static func generateMetricData(minutes: Int = 60) -> [MetricDataPoint] {
        var data: [MetricDataPoint] = []
        let now = Date()
        
        for i in 0..<minutes {
            let date = now.addingTimeInterval(-Double(i * 60))
            let value = Double.random(in: 5...85)
            data.append(MetricDataPoint(date: date, value: value))
        }
        
        return data.sorted(by: { $0.date < $1.date })
    }
    
    /// Gets shell command output for demo terminal
    static func getShellOutput(for command: String) -> String {
        let cleanCommand = command.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if let output = shellCommands[cleanCommand] {
            return output
        }
        
        // Handle echo commands
        if cleanCommand.hasPrefix("echo ") {
            let echoText = String(command.dropFirst(5))
            return echoText.replacingOccurrences(of: "\"", with: "")
        }
        
        // Handle cat commands
        if cleanCommand.hasPrefix("cat ") {
            return "File contents would appear here..."
        }
        
        // Default response
        return "Command '\(command)' executed successfully"
    }
}
