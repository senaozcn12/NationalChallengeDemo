import SwiftUI

struct HustleDaySimView: View {
    @Environment(StudentProfile.self) private var profile
    @State private var hustle: Hustle?
    @State private var step = 0
    @State private var hoursLeft = 8
    @State private var energy = 100
    @State private var money = 0
    @State private var hoursUsed = 0
    @State private var chosen: Choice?

    var body: some View {
        VStack(spacing: 24) {
            Text("Hustle Day Simulator").font(.extraLargeTitle2)
            if let hustle {
                if step < hustle.scenes.count {
                    stats
                    sceneCard(hustle)
                } else {
                    summary(hustle)
                }
            } else {
                picker
            }
            Spacer(minLength: 0)
        }
        .padding(40)
        .animation(.smooth, value: step)
        .animation(.smooth, value: chosen?.id)
        .navigationTitle("Hustle Day")
    }

    // MARK: Pick a hustle
    private var picker: some View {
        VStack(spacing: 20) {
            Text("Pick your side hustle").foregroundStyle(.secondary)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 240), spacing: 20)], spacing: 20) {
                ForEach(Hustle.all) { h in
                    Button { start(h) } label: {
                        VStack(spacing: 10) {
                            Image(systemName: h.symbol).font(.system(size: 44))
                            Text(h.name).font(.title2.bold())
                            Text(h.blurb).font(.callout).foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, minHeight: 170)
                        .padding(18)
                        .background(.regularMaterial, in: .rect(cornerRadius: 28))
                        .contentShape(.hoverEffect, .rect(cornerRadius: 28))
                        .hoverEffect()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: Floating stat cards
    private var stats: some View {
        HStack(spacing: 16) {
            StatChip(symbol: "clock", label: "Hours left", value: "\(hoursLeft)", tint: .blue)
            StatChip(symbol: "bolt.fill", label: "Energy", value: "\(energy)%", tint: energy < 35 ? .red : .orange)
            StatChip(symbol: "dollarsign.circle.fill", label: "Money made", value: "$\(money)", tint: .green)
        }
    }

    // MARK: Scene
    private func sceneCard(_ hustle: Hustle) -> some View {
        let scene = hustle.scenes[step]
        return VStack(spacing: 20) {
            Text("Moment \(step + 1) of \(hustle.scenes.count)").font(.caption).foregroundStyle(.secondary)
            Text(scene.prompt).font(.title.bold()).multilineTextAlignment(.center)

            if let chosen {
                VStack(spacing: 10) {
                    Text(chosen.note).font(.title3).multilineTextAlignment(.center)
                    HStack(spacing: 18) {
                        Text("\(chosen.hours)h")
                        Text("\(chosen.energy > 0 ? "+" : "")\(chosen.energy)% energy")
                        Text("\(chosen.money >= 0 ? "+" : "−")$\(abs(chosen.money))")
                    }
                    .font(.headline).monospacedDigit().foregroundStyle(.secondary)
                    Button(step + 1 == hustle.scenes.count ? "See how my day went" : "Next moment") {
                        self.chosen = nil
                        step += 1
                    }
                    .padding(.top, 8)
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            } else {
                HStack(spacing: 18) {
                    ForEach(scene.choices) { c in
                        Button { choose(c) } label: {
                            VStack(spacing: 6) {
                                Text(c.title).font(.headline).multilineTextAlignment(.center)
                                Text("\(c.hours)h of your day").font(.caption).foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, minHeight: 90)
                            .padding(12)
                        }
                        .buttonBorderShape(.roundedRectangle(radius: 22))
                    }
                }
            }
        }
        .padding(32)
        .frame(maxWidth: 900)
        .glassBackgroundEffect(in: .rect(cornerRadius: 32))
    }

    // MARK: Summary
    private func summary(_ hustle: Hustle) -> some View {
        let rate = hoursUsed > 0 ? Double(money) / Double(hoursUsed) : 0
        return VStack(spacing: 18) {
            Text("Your day as a \(hustle.name.lowercased()) hustler").font(.title2)
            Text("$\(money)").font(.system(size: 72, weight: .bold, design: .rounded))
            Text("earned in \(hoursUsed) hours, about $\(Int(rate.rounded()))/hour")
                .font(.title3).foregroundStyle(.secondary)
            HStack(spacing: 16) {
                StatChip(symbol: "bolt.fill", label: "Energy left", value: "\(energy)%", tint: .orange)
                StatChip(symbol: "clock", label: "Hours unused", value: "\(hoursLeft)", tint: .blue)
            }
            Text("There's no single right path. Making money is about time, energy and what you charge. Next: say who you help and why.")
                .multilineTextAlignment(.center).foregroundStyle(.secondary).frame(maxWidth: 560)
            HStack(spacing: 16) {
                Button("Try another hustle") { reset() }
                NavigationLink(value: Demo.statement) {
                    Label("Write my hustle statement", systemImage: "arrow.right")
                }
            }
        }
        .padding(32)
        .glassBackgroundEffect(in: .rect(cornerRadius: 32))
    }

    // MARK: Logic
    private func start(_ h: Hustle) {
        hustle = h
        profile.hustle = h
        step = 0; hoursLeft = 8; energy = 100; money = 0; hoursUsed = 0; chosen = nil
    }

    private func choose(_ c: Choice) {
        hoursLeft = max(0, hoursLeft - c.hours)
        hoursUsed += c.hours
        energy = min(100, max(0, energy + c.energy))
        money += c.money
        chosen = c
    }

    private func reset() {
        hustle = nil; chosen = nil; step = 0
    }
}

struct StatChip: View {
    let symbol: String
    let label: String
    let value: String
    let tint: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbol).font(.title2).foregroundStyle(tint)
            VStack(alignment: .leading) {
                Text(label).font(.caption).foregroundStyle(.secondary)
                Text(value).font(.title2.bold()).monospacedDigit()
                    .contentTransition(.numericText())
            }
        }
        .padding(.horizontal, 22).padding(.vertical, 14)
        .background(.regularMaterial, in: .capsule)
    }
}
