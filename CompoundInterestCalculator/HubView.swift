import SwiftUI

enum Demo: String, CaseIterable, Identifiable, Hashable {
    case mindset, day, niche, statement, money
    var id: String { rawValue }

    var title: String {
        switch self {
        case .mindset: "Mindset Mirror"
        case .day: "Hustle Day Simulator"
        case .niche: "Finding Your Niche"
        case .statement: "Your Hustle Statement"
        case .money: "Keep It: Compound Interest"
        }
    }
    var subtitle: String {
        switch self {
        case .mindset: "Flip a limiting thought into a stronger one."
        case .day: "Live one day as a side hustler. Every choice counts."
        case .niche: "Combine your skills, culture and people to discover your niche."
        case .statement: "I help ___ who are struggling with ___ by offering ___"
        case .money: "See how saving a little grows over time."
        }
    }
    var symbol: String {
        switch self {
        case .mindset: "sparkles"
        case .day: "clock.fill"
        case .niche: "circle.hexagongrid.fill"
        case .statement: "text.quote"
        case .money: "chart.bar.fill"
        }
    }
    var track: String {
        switch self {
        case .mindset, .day, .statement: "The Side Hustle Mindset"
        case .niche: "Finding Your Niche"
        case .money: "Don't Just Make Money, Keep It!"
        }
    }
}

struct HubView: View {
    @State private var profile = StudentProfile()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Culture Is Currency").font(.extraLargeTitle2)
                    Text("Pick a demo to explore").foregroundStyle(.secondary)
                }
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 260), spacing: 20)], spacing: 20) {
                    ForEach(Demo.allCases) { demo in
                        NavigationLink(value: demo) {
                            VStack(alignment: .leading, spacing: 10) {
                                Image(systemName: demo.symbol).font(.largeTitle)
                                Text(demo.track).font(.caption).foregroundStyle(.secondary)
                                Text(demo.title).font(.title2.bold())
                                Text(demo.subtitle).font(.callout).foregroundStyle(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, minHeight: 190, alignment: .topLeading)
                            .padding(22)
                            .background(.regularMaterial, in: .rect(cornerRadius: 28))
                            .contentShape(.hoverEffect, .rect(cornerRadius: 28))
                            .hoverEffect()
                        }
                        .buttonStyle(.plain)
                    }
                }
                Spacer(minLength: 0)
            }
            .padding(40)
            .navigationDestination(for: Demo.self) { demo in
                switch demo {
                case .mindset: MindsetMirrorView()
                case .day: HustleDaySimView()
                case .niche: NicheConstellationView()
                case .statement: StatementBuilderView()
                case .money: ContentView()
                }
            }
        }
        .environment(profile)
    }
}
