import SwiftUI

struct MindsetMirrorView: View {
    @State private var flipped: Set<UUID> = []
    private let beliefs = Belief.all

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 6) {
                Text("Mindset Mirror").font(.extraLargeTitle2)
                Text("Look at each thought. Tap it to flip it.").foregroundStyle(.secondary)
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 24)], spacing: 24) {
                ForEach(beliefs) { b in
                    card(b)
                }
            }
            Spacer(minLength: 0)
            HStack(spacing: 20) {
                Text("\(flipped.count) of \(beliefs.count) reframed")
                    .font(.headline).monospacedDigit()
                if flipped.count >= 3 {
                    NavigationLink(value: Demo.statement) {
                        Label("Now say what you do", systemImage: "arrow.right")
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.smooth, value: flipped.count)
        }
        .padding(40)
        .navigationTitle("Mindset Mirror")
    }

    private func card(_ b: Belief) -> some View {
        let isFlipped = flipped.contains(b.id)
        return ZStack {
            // Front: the limiting thought
            VStack(spacing: 12) {
                Image(systemName: "cloud.fill").font(.title).foregroundStyle(.secondary)
                Text("“\(b.thought)”").font(.title2.bold()).multilineTextAlignment(.center)
                Text("Tap to flip").font(.caption).foregroundStyle(.secondary)
            }
            .opacity(isFlipped ? 0 : 1)

            // Back: the reframe
            VStack(spacing: 12) {
                Image(systemName: "sun.max.fill").font(.title).foregroundStyle(.yellow)
                Text(b.reframe).font(.headline).multilineTextAlignment(.center)
                Divider()
                Label(b.action, systemImage: "checkmark.circle")
                    .font(.callout).foregroundStyle(.green)
                    .multilineTextAlignment(.leading)
            }
            .opacity(isFlipped ? 1 : 0)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
        .padding(24)
        .frame(maxWidth: .infinity, minHeight: 230)
        .background(isFlipped ? AnyShapeStyle(.green.opacity(0.18)) : AnyShapeStyle(.regularMaterial),
                    in: .rect(cornerRadius: 28))
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .contentShape(.hoverEffect, .rect(cornerRadius: 28))
        .hoverEffect()
        .onTapGesture {
            withAnimation(.spring(duration: 0.6)) {
                if isFlipped { flipped.remove(b.id) } else { flipped.insert(b.id) }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}
