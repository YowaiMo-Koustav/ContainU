import SwiftUI

struct ContainerSettingsView: View {
    let container: Container

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.title)
                .fontWeight(.bold)
            Text("This is a placeholder for container-specific settings such as restart policy, resource limits, environment variables, etc. Replace with real controls when backend APIs are available.")
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
}

struct ContainerSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ContainerViewModel(containerService: MockContainerService())
        return ContainerSettingsView(container: vm.containers.first!)
            .environmentObject(vm)
            .preferredColorScheme(.dark)
    }
}
