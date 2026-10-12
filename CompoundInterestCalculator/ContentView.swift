import SwiftUI
import Charts

private extension Double {
    var money: String {
        formatted(.currency(code: "USD").precision(.fractionLength(0)))
    }
}

struct ContentView: View {
    @State private var model = GrowthModel()
    @State private var selectedYear: Int?

    var body: some View {
        HStack(alignment: .top, spacing: 28) {
            controls
                .frame(width: 360)
            results
        }
        .padding(36)
        .animation(.smooth(duration: 0.35), value: model.finalBalance)
    }

    // MARK: Controls
    private var controls: some View {
        VStack(alignment: .leading, spacing: 28) {
            Text("Compound Interest")
                .font(.extraLargeTitle2)
            SliderRow(title: "Starting money",
                      valueText: model.startingMoney.money,
                      value: $model.startingMoney, range: 0...100_000, step: 500)
            SliderRow(title: "Monthly contribution",
                      valueText: model.monthlyContribution.money + "/mo",
                      value: $model.monthlyContribution, range: 0...5_000, step: 25)
            SliderRow(title: "Interest rate (yearly)",
                      valueText: String(format: "%.1f%%", model.annualRate),
                      value: $model.annualRate, range: 0...15, step: 0.1)
            SliderRow(title: "Years",
                      valueText: "\(Int(model.years)) yrs",
                      value: $model.years, range: 1...50, step: 1)
            Spacer(minLength: 0)
        }
        .padding(28)
        .glassBackgroundEffect(in: .rect(cornerRadius: 32))
    }

    // MARK: Results
    private var results: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Future value").font(.headline).foregroundStyle(.secondary)
            Text(model.finalBalance.money)
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .contentTransition(.numericText(value: model.finalBalance))
                .monospacedDigit()

            HStack(spacing: 14) {
                StatCard(label: "You put in", value: model.totalContributed.money, tint: .gray)
                StatCard(label: "Interest earned", value: model.totalInterest.money, tint: .green)
                StatCard(label: "Growth", value: String(format: "%.2f×", model.multiple), tint: .blue)
            }

            chart
            Text(readout)
                .font(.callout).foregroundStyle(.secondary).monospacedDigit()
        }
        .padding(28)
        .glassBackgroundEffect(in: .rect(cornerRadius: 32))
    }

    private var chart: some View {
        Chart {
            ForEach(model.segments) { s in
                BarMark(x: .value("Year", s.year),
                        y: .value("Amount", s.amount))
                    .foregroundStyle(by: .value("Type", s.kind))
                    .opacity(selectedYear == nil || selectedYear == s.year ? 1 : 0.45)
            }
            if let y = selectedYear {
                RuleMark(x: .value("Year", y))
                    .foregroundStyle(.white.opacity(0.4))
            }
        }
        .chartForegroundStyleScale(["You put in": Color.gray, "Interest": Color.green])
        .chartXSelection(value: $selectedYear)
        .chartYAxis {
            AxisMarks { v in
                AxisGridLine()
                AxisValueLabel {
                    if let d = v.as(Double.self) { Text(d.formatted(.currency(code: "USD").notation(.compactName))) }
                }
            }
        }
        .frame(minHeight: 280)
    }

    private var readout: String {
        guard let y = selectedYear, let p = model.points.first(where: { $0.year == y }) else {
            return "Look at a bar to see that year."
        }
        return "Year \(p.year): \(p.balance.money) total · \(p.contributed.money) put in · \(p.interest.money) interest"
    }
}

// MARK: - Components
struct SliderRow: View {
    let title: String
    let valueText: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title).foregroundStyle(.secondary)
                Spacer()
                Text(valueText).font(.title3.bold()).monospacedDigit()
                    .contentTransition(.numericText())
            }
            Slider(value: $value, in: range, step: step)
        }
    }
}

struct StatCard: View {
    let label: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(label, systemImage: "circle.fill")
                .font(.caption)
                .foregroundStyle(.secondary)
                .tint(tint)
            Text(value).font(.title3.bold()).monospacedDigit()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.thinMaterial, in: .rect(cornerRadius: 20))
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
