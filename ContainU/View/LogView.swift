import SwiftUI

struct LogView: View {
    @StateObject private var logViewModel = LogViewModel()

    var body: some View {
        VStack(spacing: 0) {
            LogFilterView(viewModel: logViewModel)
                .padding()
                .glassEffect()

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(logViewModel.filteredLogs) { entry in
                            LogRowView(logEntry: entry)
                                .id(entry.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: logViewModel.filteredLogs) {
                    if let last = logViewModel.filteredLogs.last {
                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
        }
    }
}

struct LogFilterView: View {
    @ObservedObject var viewModel: LogViewModel

    var body: some View {
        HStack {
            TextField("Search logs...", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .accessibilityLabel("Search logs")
                .accessibilityHint("Filters the log messages based on entered text.")

            ForEach(LogLevel.allCases) { level in
                Button(action: {
                    if viewModel.selectedLevels.contains(level) {
                        viewModel.selectedLevels.remove(level)
                    } else {
                        viewModel.selectedLevels.insert(level)
                    }
                }) {
                    Text(level.rawValue)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(8)
                        .background(viewModel.selectedLevels.contains(level) ? level.color.opacity(0.8) : Color.gray.opacity(0.4))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Filter by \(level.rawValue)")
                .accessibilityAddTraits(viewModel.selectedLevels.contains(level) ? .isSelected : [])
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Log filters")
    }
}

struct LogRowView: View {
    let logEntry: LogEntry

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(Self.dateFormatter.string(from: logEntry.timestamp))
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.secondary)

            Text(logEntry.level.rawValue)
                .font(.system(.body, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(logEntry.level.color)

            Text(logEntry.message)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Timestamp: \(Self.dateFormatter.string(from: logEntry.timestamp)), Level: \(logEntry.level.rawValue), Message: \(logEntry.message)")
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
