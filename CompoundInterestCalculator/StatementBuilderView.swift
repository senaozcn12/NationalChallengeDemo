import SwiftUI
import UIKit

/// "I help ____ who are struggling with ____ by offering ____"
struct StatementBuilderView: View {
    @Environment(StudentProfile.self) private var profile

    private let fallbackWho = ["teens", "college students", "busy parents"]
    private let fallbackStruggle = ["saving money", "finding affordable help", "standing out"]
    private let fallbackOffering = ["a service made for them", "fair prices", "a personal touch"]

    var body: some View {
        @Bindable var profile = profile
        let h = profile.hustle

        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Your Hustle Statement").font(.extraLargeTitle2)
                Text(h == nil
                     ? "Fill in the blanks. Tip: play the Hustle Day Simulator first to get ideas."
                     : "Ideas based on your \(h!.name.lowercased()) hustle. Tap one or type your own.")
                    .foregroundStyle(.secondary)

                preview(profile)

                field("I help…", text: $profile.who, suggestions: h?.who ?? fallbackWho,
                      hint: "Who exactly? The more specific, the better.")
                field("who are struggling with…", text: $profile.struggle,
                      suggestions: h?.struggles ?? fallbackStruggle,
                      hint: "What problem do they have right now?")
                field("by offering…", text: $profile.offering,
                      suggestions: h?.offerings ?? fallbackOffering,
                      hint: "What do you give them to solve it?")

                checklist(profile)

                Button {
                    UIPasteboard.general.string = sentence(profile)
                } label: {
                    Label("Copy my statement", systemImage: "doc.on.doc")
                }
                .disabled(!complete(profile))
            }
            .padding(40)
        }
        .navigationTitle("Hustle Statement")
    }

    private func complete(_ p: StudentProfile) -> Bool {
        ![p.who, p.struggle, p.offering].contains { $0.trimmingCharacters(in: .whitespaces).isEmpty }
    }

    private func sentence(_ p: StudentProfile) -> String {
        "I help \(p.who) who are struggling with \(p.struggle) by offering \(p.offering)."
    }

    private func preview(_ p: StudentProfile) -> some View {
        func blank(_ s: String) -> Text {
            s.isEmpty ? Text("_____").foregroundColor(.secondary)
                      : Text(s).bold().foregroundColor(.green)
        }
        return (Text("I help ") + blank(p.who)
                + Text(" who are struggling with ") + blank(p.struggle)
                + Text(" by offering ") + blank(p.offering) + Text("."))
            .font(.title)
            .padding(28)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassBackgroundEffect(in: .rect(cornerRadius: 28))
    }

    private func field(_ label: String, text: Binding<String>, suggestions: [String], hint: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label).font(.title3.bold())
            Text(hint).font(.callout).foregroundStyle(.secondary)
            TextField("Type your own…", text: text)
                .textFieldStyle(.roundedBorder)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(suggestions, id: \.self) { s in
                        Button(s) { text.wrappedValue = s }
                            .buttonBorderShape(.capsule)
                    }
                }
            }
        }
    }

    private func checklist(_ p: StudentProfile) -> some View {
        func words(_ s: String) -> Int { s.split(separator: " ").count }
        let items: [(String, Bool)] = [
            ("Specific group (2+ words, not just “everyone”)", words(p.who) >= 2),
            ("A real problem they have", words(p.struggle) >= 2),
            ("A clear offer you can deliver", words(p.offering) >= 2)
        ]
        return VStack(alignment: .leading, spacing: 8) {
            Text("Does it pass the test?").font(.headline)
            ForEach(items, id: \.0) { item in
                Label(item.0, systemImage: item.1 ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(item.1 ? .green : .secondary)
            }
        }
    }
}
