import SwiftUI
import Charts

// MARK: - Main Metrics View

struct MetricsView: View {
    @StateObject private var viewModel = MetricsViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Real-Time Performance")
                    .font(.title.bold())
                    .foregroundStyle(.primary)

                HStack(spacing: 24) {
                    GaugeView(
                        value: viewModel.cpuData.last?.value ?? 0,
                        total: 100,
                        label: "CPU Usage",
                        color: .blue,
                        unit: "%"
                    )
                    
                    GaugeView(
                        value: viewModel.memoryData.last?.value ?? 0,
                        total: 512,
                        label: "Memory Usage",
                        color: .green,
                        unit: "MB"
                    )
                }
                
                NetworkChartView(
                    data: viewModel.networkData,
                    color: .orange,
                    unit: "MB/s"
                )
            }
            .padding()
        }
        .background(Color.clear)
    }
}

// MARK: - Animated Radial Gauge

struct GaugeView: View {
    var value: Double
    var total: Double
    var label: String
    var color: Color
    var unit: String

    @State private var animatedValue: Double = 0

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: 20)

                Circle()
                    .trim(from: 0, to: CGFloat(animatedValue / total))
                    .stroke(color, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .shadow(color: color.opacity(0.5), radius: 5, x: 0, y: 3)

                VStack {
                    Text(String(format: "%.0f", animatedValue))
                        .font(.largeTitle.bold())
                        .contentTransition(.numericText())
                    Text(unit)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(20)
            
            Text(label)
                .font(.headline)
                .fontWeight(.medium)
        }
        .padding()
        .background(.ultraThinMaterial)
        .glassEffect()
        .cornerRadius(20)
        .onChange(of: value) {
            withAnimation(.easeInOut(duration: 0.8)) {
                self.animatedValue = value
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                self.animatedValue = value
            }
        }
    }
}

// MARK: - Modern Network Chart

struct NetworkChartView: View {
    let data: [MetricDataPoint]
    let color: Color
    let unit: String

    var body: some View {
        VStack(alignment: .leading) {
            Text("Network I/O")
                .font(.headline)
                .fontWeight(.medium)

            Chart(data) {
                AreaMark(
                    x: .value("Time", $0.date),
                    y: .value("Value", $0.value)
                )
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [color.opacity(0.6), .clear]), startPoint: .top, endPoint: .bottom))
                
                LineMark(
                    x: .value("Time", $0.date),
                    y: .value("Value", $0.value)
                )
                .foregroundStyle(color)
                .symbol(Circle().strokeBorder(lineWidth: 2))
            }
            .chartYScale(domain: 0...50)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine(stroke: StrokeStyle(dash: [3, 3]))
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            Text("\(intValue) \(unit)").font(.caption)
                        }
                    }
                }
            }
            .frame(height: 200)
        }
        .padding()
        .background(.ultraThinMaterial)
        .glassEffect()
        .cornerRadius(20)
    }
}

// MARK: - Previews

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
            .frame(width: 600, height: 600)
            .preferredColorScheme(.dark)
    }
}
