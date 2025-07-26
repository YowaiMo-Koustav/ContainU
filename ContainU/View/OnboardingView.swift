import SwiftUI

/// Simple multi-page onboarding presented on first launch.
struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var page = 0

    private let pages: [(title: String, systemImage: String, description: String)] = [
        ("Welcome to ContainU", "shippingbox", "Visualise, monitor and control your containers with beautiful Liquid-Glass UI."),
        ("Multi-container Control", "cursorarrow.rays", "Select multiple containers and batch start, stop, restart or delete them with one click."),
        ("Real-time Metrics", "chart.bar", "Track CPU, memory and network utilisation in live updating charts."),
        ("Network Topology", "point.topleft.down.curvedto.point.bottomright.up", "Understand connectivity at a glance with interactive graph view."),
    ]

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: pages[page].systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.accentColor)
                .transition(.scale.combined(with: .opacity))

            Text(pages[page].title)
                .font(.largeTitle.bold())

            Text(pages[page].description)
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            HStack {
                ForEach(0..<pages.count, id: \.self) { idx in
                    Circle()
                        .fill(idx == page ? Color.accentColor : Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                        .animation(.easeInOut, value: page)
                }
            }

            Button(action: next) {
                Text(page == pages.count - 1 ? "Get Started" : "Next")
                    .font(.headline)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(Color.accentColor))
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)
            .transition(.opacity)
        }
        .padding(.vertical, 40)
        .frame(minWidth: 500, minHeight: 500)
        .glassEffect()
    }

    private func next() {
        if page < pages.count - 1 {
            withAnimation(.easeInOut) { page += 1 }
        } else {
            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
            dismiss()
        }
    }
}

#Preview {
    OnboardingView()
}
