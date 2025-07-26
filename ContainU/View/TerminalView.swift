import SwiftUI

struct TerminalView: View {
    @State private var command: String = ""
    @State private var history: [String] = [
        "Last login: \(Date().description)",
        "Welcome to ContainU Terminal!",
        "",
        "$ ls -la",
        "total 8",
        "drwxr-xr-x  1 root root 4096 Jul 17 10:30 .",
        "drwxr-xr-x  1 root root 4096 Jul 17 10:30 ..",
        "-rw-r--r--  1 root root    0 Jul 17 10:30 .bash_history",
        "",
        "$ echo 'Hello from ContainU!'",
        "Hello from ContainU!",
    ]

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(history, id: \.self) { line in
                            if line.trimmingCharacters(in: .whitespaces).hasPrefix("$") {
                                Text(line)
                                    .foregroundColor(.green)
                                    .id(line)
                                    .accessibilityLabel("Command: \(line)")
                            } else {
                                Text(line)
                                    .foregroundColor(.white)
                                    .id(line)
                                    .accessibilityLabel("Output: \(line)")
                            }
                        }
                    }
                    .padding()
                }
                .accessibilityLabel("Terminal history")
                .onChange(of: history) {
                    if let last = history.last {
                        withAnimation {
                            proxy.scrollTo(last, anchor: .bottom)
                        }
                    }
                }
            }
            
            HStack(spacing: 8) {
                Text("$")
                TextField("Enter command...", text: $command, onCommit: {
                    history.append("$ \(command)")
                    // In a real implementation, you would execute the command here.
                    history.append("Command not found: \(command)")
                    command = ""
                })
                .textFieldStyle(PlainTextFieldStyle())
                .accessibilityLabel("Command Input")
                .accessibilityHint("Type a shell command and press Enter to execute.")
            }
            .padding()
            .background(Color.black.opacity(0.2))
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Command Prompt")
        }
        .font(.system(.body, design: .monospaced))
        .background(Color.black.opacity(0.8))
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}

struct TerminalView_Previews: PreviewProvider {
    static var previews: some View {
        TerminalView()
    }
}
