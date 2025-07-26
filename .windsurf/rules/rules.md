---
trigger: always_on
---

// .windsurf/rules.md

# Workspace-Level Windsurf Rules

## Sidebar & Layout
- Sections: **Containers**, **Images**, **Networks**, **Volumes**, **Topology**.  
- Finder-style sidebar + toolbar + content area.  
- Sidebar collapses to icons-only view on narrow windows; icons use SF Symbols.

## Toolbar & Actions
- Toolbar items: **Search**, **View Toggle (List/Grid)**, **Manage Menu**, **+** action button.  
- Floating “+” button must use `.glassEffect()` and drop shadow.

## Content Views
- **List columns** must match PDF mockups: Name, Tag/Ports, Status/Uptime, Created, Size.  
- **Detail view tabs**: Overview, Logs, Terminal, Networks, Volumes.  
- **Overview**: Show CPU, Memory, Uptime cards with radial gauges.  
- **Logs**: Scrollable list with fake timestamped entries; auto-append.  
- **Terminal**: Input editor + output panel; echo canned responses.  
- **Networks/Volumes**: Tables with Driver, IP/Size columns; clicking shows glass-styled detail modal.

## Styling & Effects
- Wrap main window title bar, sidebar, toolbars, modals, context menus in `.glassEffect()` or `Material.thick`.  
- Use `.background(.ultraThinMaterial)` for sidebars and panels.  
- Add rounded corners and subtle drop shadows (`.shadow(color: .black.opacity(0.2), radius: 5)`).  
- Ensure dynamic dark/light adaptation and macOS accent color integration.

## Interactivity & Animations
- Wrap all state changes in `withAnimation(.easeInOut(duration: 0.3))`.  
- Simulate latency using `try await Task.sleep(nanoseconds: 300_000_000)`.  
- Sort/filter/search lists instantly or with brief fake delay.  
- Use `matchedGeometryEffect` for smooth list↔detail transitions.

## Fake Data & Services
- Implement `MockContainerService` with stubbed methods: `pullImage`, `listImages`, `removeImage`, `createContainer`, `startContainer`, `stopContainer`, `removeContainer`, `fetchLogs`, `executeShell`.  
- Store sample data arrays in `FakeData.swift` (images, containers, networks, volumes, logs).  
- Bind mock service via `@EnvironmentObject` in view models.

## Accessibility & Testing
- Add `.accessibilityLabel` and `.accessibilityHint` on all controls.  
- Support keyboard navigation (arrow keys, Enter, Cmd shortcuts).  
- Prepare one XCUITest script to verify UI flows end-to-end under fake data.

# Reference Links:
https://github.com/apple/containerization
https://developer.apple.com/design/human-interface-guidelines/
https://docs.swift.org/swift-book/documentation/the-swift-programming-language
https://developer.apple.com/documentation/technologyoverviews/app-design-and-uihttps://developer.apple.com/documentation/technologyoverviews/swiftuihttps://developer.apple.com/documentation/technologyoverviews/uikit-appkithttps://developer.apple.com/documentation/technologyoverviews/interface-fundamentalshttps://developer.apple.com/documentation/technologyoverviews/liquid-glasshttps://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass
https://developer.apple.com/design/human-interface-guidelines/componentshttps://developer.apple.com/design/human-interface-guidelines/inputs
https://developer.apple.com/documentation/updates/wwdc2025/https://developer.apple.com/design/human-interface-guidelines/foundationshttps://developer.apple.com/design/human-interface-guidelines/patternshttps://developer.apple.com/design/human-interface-guidelines/toolbarshttps://developer.apple.com/design/human-interface-guidelines/iconshttps://developer.apple.com/design/human-interface-guidelines/materials