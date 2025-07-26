import SwiftUI

struct CreateContainerView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ContainerViewModel

    @State private var name: String = ""
    @State private var image: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Create New Container")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 16) {
                TextField("Container Name (e.g., my-awesome-app)", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Image Name (e.g., nginx:latest)", text: $image)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Spacer()

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Create") {
                    Task {
                        await viewModel.createContainer(name: name, image: image)
                        dismiss()
                    }
                }
                .disabled(name.isEmpty || image.isEmpty)
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(30)
        .frame(width: 500, height: 300)
        .glassEffect()
    }
}
