import SwiftUI

struct NicheConstellationView: View {
    @Environment(StudentProfile.self) private var profile
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var ns
    @State private var picks: [Ring: Orb] = [:]

    private let orbSize: CGFloat = 100

    private var niche: Niche? {
        guard let s = picks[.skill], let c = picks[.culture], let p = picks[.people] else { return nil }
        return NicheData.make(skill: s, culture: c, person: p)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 28) {
            VStack(alignment: .leading, spacing: 18) {
                Text("Finding Your Niche").font(.extraLargeTitle2)
                Text("Tap one orb from each ring to pull it into the center.")
                    .foregroundStyle(.secondary)
                ForEach(Ring.allCases) { ringRow($0) }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            fusionPanel.frame(width: 460)
        }
        .padding(40)
        .navigationTitle("Finding Your Niche")
        .onChange(of: niche?.title) { _, _ in
            // Send the result to the statement builder's blanks.
            if let n = niche {
                profile.who = n.who
                profile.struggle = n.struggle
                profile.offering = n.offering
            }
        }
    }

    // MARK: Rings of orbs
    private func ringRow(_ ring: Ring) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(ring.title).font(.headline).foregroundStyle(ring.color)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(Array(ring.orbs.enumerated()), id: \.element.id) { index, orb in
                        if picks[ring] == orb {
                            placeholder(ring, dashed: true)
                        } else {
                            orbView(orb, ring: ring, phase: Double(index) * 1.3, bobbing: true)
                                .matchedGeometryEffect(id: orb.id, in: ns)
                                .onTapGesture { pick(orb, in: ring) }
                        }
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 4)
            }
        }
    }

    private func orbView(_ orb: Orb, ring: Ring, phase: Double, bobbing: Bool) -> some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: reduceMotion || !bobbing)) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            let dy = (bobbing && !reduceMotion) ? sin(t * 1.2 + phase) * 5 : 0
            ZStack {
                Circle()
                    .fill(RadialGradient(colors: [ring.color.opacity(0.9), ring.color.opacity(0.35)],
                                         center: .topLeading, startRadius: 4, endRadius: orbSize * 1.1))
                    .overlay(Circle().strokeBorder(.white.opacity(0.35), lineWidth: 1.5))
                    .shadow(color: ring.color.opacity(0.45), radius: 12, y: 6)
                VStack(spacing: 4) {
                    Image(systemName: orb.symbol).font(.title3)
                    Text(orb.label)
                        .font(.caption2.bold())
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .minimumScaleFactor(0.7)
                }
                .foregroundStyle(.white)
                .padding(10)
            }
            .frame(width: orbSize, height: orbSize)
            .offset(y: dy)
        }
        .frame(width: orbSize, height: orbSize)
        .contentShape(.hoverEffect, .circle)
        .hoverEffect()
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }

    private func placeholder(_ ring: Ring, dashed: Bool) -> some View {
        Circle()
            .fill(ring.color.opacity(0.08))
            .overlay(Circle().strokeBorder(ring.color.opacity(0.5),
                                           style: StrokeStyle(lineWidth: 2, dash: dashed ? [6, 6] : [])))
            .frame(width: orbSize, height: orbSize)
    }

    // MARK: Center
    private var fusionPanel: some View {
        VStack(spacing: 22) {
            HStack(spacing: 12) {
                slot(.skill)
                Text("+").font(.title.bold()).foregroundStyle(.secondary)
                slot(.culture)
                Text("+").font(.title.bold()).foregroundStyle(.secondary)
                slot(.people)
            }

            if let niche {
                VStack(spacing: 12) {
                    Label("Your niche", systemImage: "sparkles")
                        .font(.caption).foregroundStyle(.yellow)
                    Text(niche.title)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                    Text(niche.sentence)
                        .font(.callout).foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    NavigationLink(value: Demo.statement) {
                        Label("Build my statement", systemImage: "arrow.right")
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(.yellow.opacity(0.12), in: .rect(cornerRadius: 24))
                .shadow(color: .yellow.opacity(0.35), radius: 18)
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            } else {
                Text("Pick a skill, a culture and the people you'd help. Your niche appears here.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, minHeight: 120)
            }

            HStack(spacing: 12) {
                Button { surprise() } label: { Label("Surprise me", systemImage: "dice.fill") }
                Button { withAnimation(.spring(duration: 0.5)) { picks = [:] } } label: {
                    Label("Start over", systemImage: "arrow.counterclockwise")
                }
                .disabled(picks.isEmpty)
            }
            Text("125 possible niches").font(.caption).foregroundStyle(.secondary)
        }
        .padding(24)
        .glassBackgroundEffect(in: .rect(cornerRadius: 32))
        .animation(.spring(duration: 0.5), value: niche?.title)
    }

    private func slot(_ ring: Ring) -> some View {
        ZStack {
            placeholder(ring, dashed: true)
            if let orb = picks[ring] {
                orbView(orb, ring: ring, phase: 0, bobbing: false)
                    .matchedGeometryEffect(id: orb.id, in: ns)
                    .onTapGesture { withAnimation(.spring(duration: 0.5)) { picks[ring] = nil } }
            } else {
                Text(ring.title).font(.caption).foregroundStyle(ring.color)
            }
        }
        .frame(width: orbSize, height: orbSize)
    }

    // MARK: Actions
    private func pick(_ orb: Orb, in ring: Ring) {
        withAnimation(.spring(duration: 0.5)) { picks[ring] = orb }
    }

    private func surprise() {
        withAnimation(.spring(duration: 0.6)) {
            picks[.skill] = NicheData.skills.randomElement()
            picks[.culture] = NicheData.cultures.randomElement()
            picks[.people] = NicheData.people.randomElement()
        }
    }
}
