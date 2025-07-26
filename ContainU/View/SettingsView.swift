import SwiftUI

struct SettingsView: View {
    @AppStorage("pref_dark_mode") private var prefersDark = false
    @AppStorage("pref_refresh_interval") private var refreshInterval: Double = 2.0

    var body: some View {
        Form {
            Toggle("Prefer Dark Mode", isOn: $prefersDark)
            HStack {
                Text("Metrics Refresh Interval")
                Slider(value: $refreshInterval, in: 0.5...10, step: 0.5)
                Text("\(refreshInterval, specifier: "%.1f")s")
            }
        }
        .padding(30)
        .frame(width: 400)
    }
}

#Preview {
    SettingsView()
}
