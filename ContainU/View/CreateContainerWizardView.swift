import SwiftUI

/// A lightweight, 3-step wizard for creating a container with optional network & volume selection.
struct CreateContainerWizardView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var vm: ContainerViewModel

    private enum WizardStep: Int, CaseIterable { case info, networks, volumes, review }

    // MARK: - State
    @State private var step: WizardStep = .info
    @State private var name = ""
    @State private var image = ""
    @State private var selectedNetworks: Set<String> = []
    @State private var selectedVolumes: Set<String> = []

    // MARK: - Body
    var body: some View {
        VStack(spacing: 24) {
            header
            Divider()
            stepView
            Spacer()
            footer
        }
        .padding(30)
        .frame(minWidth: 520, minHeight: 420)
        .glassEffect()
        .animation(.easeInOut, value: step)
    }

    // MARK: Views
    private var header: some View {
        HStack {
            Text("New Container")
                .font(.title2.bold())
            Spacer()
            ProgressView(value: Double(step.rawValue), total: Double(WizardStep.allCases.count - 1))
                .frame(width: 120)
                .accessibilityLabel("Step \(step.rawValue + 1) of \(WizardStep.allCases.count)")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("New Container Wizard Header")
    }

    @ViewBuilder private var stepView: some View {
        switch step {
        case .info: basicInfoView
        case .networks: networkPickView
        case .volumes: volumePickView
        case .review: reviewView
        }
    }

    private var basicInfoView: some View {
        VStack(alignment: .leading, spacing: 18) {
            TextField("Container Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibilityLabel("Container Name")
                .accessibilityHint("Enter a unique name for the new container.")
            TextField("Image (e.g. nginx:latest)", text: $image)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibilityLabel("Image Name")
                .accessibilityHint("Enter the Docker image name and tag, for example, 'nginx:latest'.")
            Spacer()
        }
    }

    private var networkPickView: some View {
        List(vm.networks, id: \.name, selection: $selectedNetworks) { net in
            Label(net.name, systemImage: "network")
        }
        .accessibilityLabel("Network Selection")
        .accessibilityHint("Select one or more networks to attach to the container.")
    }

    private var volumePickView: some View {
        List(vm.volumes, id: \.name, selection: $selectedVolumes) { vol in
            Label(vol.name, systemImage: "externaldrive")
        }
        .accessibilityLabel("Volume Selection")
        .accessibilityHint("Select one or more volumes to mount to the container.")
    }

    private var reviewView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Name: \(name)")
            Text("Image: \(image)")
            Text("Networks: \(selectedNetworks.joined(separator: ", "))")
            Text("Volumes: \(selectedVolumes.joined(separator: ", "))")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Review Container Configuration. Name: \(name). Image: \(image). Networks: \(selectedNetworks.joined(separator: ", ")). Volumes: \(selectedVolumes.joined(separator: ", ")).")
    }

    private var footer: some View {
        HStack {
            Button("Cancel") { dismiss() }
                .accessibilityHint("Closes the wizard without creating a container.")
            Spacer()
            Group {
                if step != .info {
                    Button("Back") { step = WizardStep(rawValue: step.rawValue - 1)! }
                        .accessibilityHint("Returns to the previous step.")
                }
                Button(step == .review ? "Create" : "Next") {
                    if step == .review {
                        Task {
                            await vm.createContainer(name: name, image: image, networks: Array(selectedNetworks), volumes: Array(selectedVolumes))
                            dismiss()
                        }
                    } else {
                        advance()
                    }
                }
                .disabled(disabledNext)
                .accessibilityLabel(step == .review ? "Create Container" : "Next Step")
                .accessibilityHint(step == .review ? "Creates and starts the new container." : "Proceeds to the next step in the wizard.")
            }
            .keyboardShortcut(.defaultAction)
        }
    }

    // MARK: Helpers
    private var disabledNext: Bool {
        switch step {
        case .info: return name.isEmpty || image.isEmpty
        default: return false
        }
    }

    private func advance() {
        step = WizardStep(rawValue: step.rawValue + 1)!
    }
}

struct CreateContainerWizardView_Previews: PreviewProvider {
    static var previews: some View {
        CreateContainerWizardView()
            .environmentObject(ContainerViewModel(containerService: MockContainerService()))
            .preferredColorScheme(.dark)
    }
}
