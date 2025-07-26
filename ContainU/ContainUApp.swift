//
//  ContainUApp.swift
//  ContainU
//
//  Created by KOUSTAV MALLICK on 17/07/25.
//

import SwiftUI

@main
struct ContainUApp: App {
    #if FAKE_BACKEND
    @StateObject private var containerService = MockContainerService()
    #else
    @StateObject private var containerService = ContainerService()
    #endif
    
    var body: some Scene {
        WindowGroup("ContainU") {
            ContentView(containerService: containerService)
                .frame(minWidth: 900, minHeight: 600)
                .background(.ultraThinMaterial)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
        .defaultSize(width: 1100, height: 700)
    
        Settings {
            SettingsView()
        }
    }
}

