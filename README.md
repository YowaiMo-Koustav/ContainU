# ContainU

**ContainU** is a next-generation macOS application for seamless OCI container and image management, designed exclusively for the advanced features of macOS 26 Beta. Experience lightning-fast workflows and breathtaking aesthetics powered by Apple’s cutting-edge Containerization framework and pioneering Liquid Glass UI effects.

---

## ✨ Key Features

- **Stunning Modern Interface:** Explore your containers and images in a beautifully translucent Finder-style layout, enhanced by dynamic Liquid Glass and vibrant system materials.
- **Full Spectrum Container Management:** Effortlessly pull, list, remove, and manage images and containers—all in a crisp, natural workflow.
- **Live Metrics and Detail:** Track live CPU, memory, uptime, and network stats, with real-time animated charts and gauges in the Overview panel.
- **Multi-Tab Detail View:** Investigate every aspect in rich, glass-powered tabs for Overview, Logs, Terminal, Networks, and Volumes.
- **Dark & Light Mode Perfection:** Instantly adapts to your system theme, maintaining perfect contrast, vibrancy, and clarity.
- **Accessibility at the Core:** Intuitive keyboard navigation, VoiceOver support, and best-in-class color and font choices make ContainU accessible for everyone.

---

## 🚀 Getting Started

**Requirements:**
- MacBook Air M1 (2020+) with macOS 26 Beta
- Xcode 26 Beta (latest available)
- [Containerization.framework](https://github.com/apple/containerization) installed

**Quick Launch:**
- Fork this repo
- Clone Repo in your local
- Open ContainU.xcodeproj
- Select the `ContainU` scheme, build (⌘B), and run (⌘R).

---

## 🖥️ How It Works

- Deep integration with Apple's new Containerization framework: All major image/container operations are available directly within the familiar, powerful desktop environment.
- SwiftUI + Combine MVVM core: Enjoy seamless data flow, crisp animations, and responsive controls.
- System-level security, dark/light theme adherence, accessibility support, and localization readiness—all by default.
- Liquid Glass technology: Every major surface—windows, toolbars, lists, modals—glimmers with depth, focus, and elegant blur.

---

## 💡 Pro Tips

- Rapidly add, start, or remove containers using the intuitive action menu and floating glass buttons.
- Switch between detailed logs and real-time terminal access with a single click from the rich tab interface.
- Use keyboard navigation and system shortcuts (⌘1-5) to instantly jump between sidebar sections.
- Open the app in both light and dark mode for an entirely new visual experience.

---

## 🛠 Development Overview

**Architecture:**
- Modular SwiftUI (MVVM) structure: all ViewModels and Services are cleanly separated and injected via `@EnvironmentObject`.
- UI components are fully reusable and tested across screen sizes, including resizable sidebar and window layouts.
- Adopts the latest Apple Human Interface Guidelines in every view and interaction.

**Directory Structure:**
- `/Views` — Slick SwiftUI screens and reusable components
- `/ViewModels` — Data logic, state, and business actions
- `/Services` — Wrappers for container/image operations via Containerization API
- `/Resources` — Assets, iconography, and mock data
- `/Testing` — UI and accessibility tests

---

## 🤝 Contributing

Pull requests welcome! Whether it’s refining UI, improving accessibility, or enhancing logic, contributions that keep ContainU beautiful and modern are invited. Please follow Apple HIG and Liquid Glass best practices in all submissions.

---
