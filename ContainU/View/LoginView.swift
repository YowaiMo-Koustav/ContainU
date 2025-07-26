import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @State private var registry = ""
    @State private var username = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case registry, username, password
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Registry Login")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "server.rack")
                        .foregroundColor(.secondary)
                    TextField("Registry (e.g., docker.io)", text: $registry)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($focusedField, equals: .registry)
                }
                .padding()
                .background(.thickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(focusedField == .registry ? Color.accentColor : Color.clear, lineWidth: 2)
                )

                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.secondary)
                    TextField("Username", text: $username)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($focusedField, equals: .username)
                }
                .padding()
                .background(.thickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(focusedField == .username ? Color.accentColor : Color.clear, lineWidth: 2)
                )

                HStack {
                    Image(systemName: "key.fill")
                        .foregroundColor(.secondary)
                    SecureField("Password", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                        .focused($focusedField, equals: .password)
                }
                .padding()
                .background(.thickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(focusedField == .password ? Color.accentColor : Color.clear, lineWidth: 2)
                )
            }

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Login") {
                    // TODO: Handle login logic
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(username.isEmpty || password.isEmpty)
            }
        }
        .padding(32)
        .frame(width: 400)
        .background(.ultraThinMaterial)
        .glassEffect()
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)
        .onAppear {
            focusedField = .registry
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
