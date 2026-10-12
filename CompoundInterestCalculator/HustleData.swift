import SwiftUI
import Observation

/// Shared between demos so the student's answers carry over.
@Observable
final class StudentProfile {
    var hustle: Hustle?
    var who = ""
    var struggle = ""
    var offering = ""
}

struct Choice: Identifiable {
    let id = UUID()
    let title: String
    let hours: Int      // time spent
    let energy: Int     // change in energy (negative = tiring)
    let money: Int      // net cash change
    let note: String    // what happened
    init(_ title: String, h: Int, e: Int, m: Int, note: String) {
        self.title = title; hours = h; energy = e; money = m; self.note = note
    }
}

struct DayScene: Identifiable {
    let id = UUID()
    let prompt: String
    let choices: [Choice]
}

struct Hustle: Identifiable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let blurb: String
    let scenes: [DayScene]
    let who: [String]
    let struggles: [String]
    let offerings: [String]

    static func == (a: Hustle, b: Hustle) -> Bool { a.id == b.id }
    func hash(into h: inout Hasher) { h.combine(id) }

    static let all: [Hustle] = [braiding, sneakers, tutoring, catering]

    static let braiding = Hustle(
        id: "braiding", name: "Braiding", symbol: "sparkles",
        blurb: "Style hair from home or on the go.",
        scenes: [
            DayScene(prompt: "A client wants a full set of knotless braids. It's a 5-hour job.", choices: [
                Choice("Book her at $150", h: 5, e: -25, m: 150, note: "Big payout, long day."),
                Choice("Offer a quicker style for $60", h: 2, e: -10, m: 60, note: "Faster, and there's room for another client.")]),
            DayScene(prompt: "Your hair supply is running low.", choices: [
                Choice("Buy in bulk for $40", h: 1, e: -5, m: -40, note: "Costs now, saves money on every job later."),
                Choice("Make do with what you have", h: 0, e: 0, m: 0, note: "Free today, but you may turn down a client tomorrow.")]),
            DayScene(prompt: "A cousin posts your work and the DMs start flooding in.", choices: [
                Choice("Reply to everyone tonight", h: 2, e: -20, m: 80, note: "Booked 2 new clients, but you're wiped."),
                Choice("Reply tomorrow after rest", h: 0, e: 10, m: 30, note: "Booked 1 client and stayed fresh.")])
        ],
        who: ["busy college students", "women with natural hair", "parents getting kids ready for school"],
        struggles: ["finding a stylist who respects their time", "protective styles that last", "salon prices they can't afford"],
        offerings: ["knotless braids that last 6+ weeks at student prices", "mobile braiding at their home", "weekend and evening appointments"])

    static let sneakers = Hustle(
        id: "sneakers", name: "Sneaker Resale", symbol: "shoeprints.fill",
        blurb: "Find, flip and sell sneakers.",
        scenes: [
            DayScene(prompt: "A pair you bought for $90 is suddenly hyped online.", choices: [
                Choice("Sell now for $140", h: 1, e: -5, m: 50, note: "Quick profit and the cash is yours."),
                Choice("Hold for a week", h: 0, e: 0, m: 0, note: "It could go up or down. No cash today.")]),
            DayScene(prompt: "A local release has a line at 6am.", choices: [
                Choice("Wait in line and flip a pair", h: 3, e: -30, m: 70, note: "Good profit, rough morning."),
                Choice("Skip it and research prices", h: 1, e: 0, m: 0, note: "No money today, but you learn what sells.")]),
            DayScene(prompt: "A buyer says your price is too high.", choices: [
                Choice("Drop the price $15 and sell", h: 1, e: -5, m: 55, note: "A sale, but a smaller one."),
                Choice("Show proof it's authentic and hold the price", h: 1, e: -10, m: 85, note: "Trust justified the price.")])
        ],
        who: ["teens who miss limited drops", "collectors who can't find their size", "budget-minded sneakerheads"],
        struggles: ["finding authentic pairs", "sold-out releases", "overpaying on big marketplaces"],
        offerings: ["verified authentic pairs at fair prices", "a size-finding service", "cleaning and restoring"])

    static let tutoring = Hustle(
        id: "tutoring", name: "Tutoring", symbol: "book.fill",
        blurb: "Help students learn what's hard.",
        scenes: [
            DayScene(prompt: "A parent asks for weekly sessions.", choices: [
                Choice("$25/hr, one student", h: 1, e: -10, m: 25, note: "Steady and simple."),
                Choice("Group of 3 at $15 each", h: 2, e: -20, m: 45, note: "More money per hour, more energy.")]),
            DayScene(prompt: "A student cancels at the last minute.", choices: [
                Choice("Charge a $10 cancellation fee", h: 0, e: 0, m: 10, note: "A clear policy protects your time."),
                Choice("Let it go and fill the slot with practice", h: 1, e: -5, m: 0, note: "Good will, no income.")]),
            DayScene(prompt: "Exams are next week and demand spikes.", choices: [
                Choice("Add evening sessions", h: 3, e: -30, m: 75, note: "Great income, long day."),
                Choice("Make a $10 study guide to sell", h: 3, e: -15, m: 40, note: "It can sell again and again.")])
        ],
        who: ["middle schoolers", "high school juniors", "first-gen college students"],
        struggles: ["math homework", "SAT/ACT prep", "feeling lost in class"],
        offerings: ["one-on-one sessions in plain language", "affordable small-group sessions", "study guides made for their class"])

    static let catering = Hustle(
        id: "catering", name: "Catering", symbol: "fork.knife",
        blurb: "Cook for groups and events.",
        scenes: [
            DayScene(prompt: "A church group wants 20 plates for an event.", choices: [
                Choice("Accept at $12/plate", h: 4, e: -30, m: 120, note: "Profit after ingredients."),
                Choice("Ask for $15/plate", h: 4, e: -30, m: 180, note: "She said yes. Asking paid off.")]),
            DayScene(prompt: "A friend offers to help you cook.", choices: [
                Choice("Pay her $30 to help", h: 0, e: 10, m: -30, note: "You finished faster and felt better."),
                Choice("Do it all yourself", h: 2, e: -25, m: 0, note: "No extra cost, but a long night.")]),
            DayScene(prompt: "The customer asks for a menu and a receipt.", choices: [
                Choice("Make a simple menu and invoice", h: 1, e: -5, m: 20, note: "Looked professional and got a $20 tip."),
                Choice("Skip it this time", h: 0, e: 0, m: 0, note: "Saved time, missed a chance to look pro.")])
        ],
        who: ["church and community groups", "student clubs", "families hosting events"],
        struggles: ["feeding a crowd on a budget", "finding food that tastes homemade", "planning a menu"],
        offerings: ["homemade plates in bulk", "a simple custom menu", "pickup or delivery"])
}

struct Belief: Identifiable {
    let id = UUID()
    let thought: String
    let reframe: String
    let action: String
}

extension Belief {
    static let all: [Belief] = [
        Belief(thought: "I'm not business-minded.",
               reframe: "Business is a skill, not a personality. Every owner started by trying one thing.",
               action: "Write down one thing people already ask you for help with."),
        Belief(thought: "I don't have money to start.",
               reframe: "Many hustles start with a skill and a phone. Start with what you can offer today.",
               action: "List 3 things you can sell with $0."),
        Belief(thought: "Someone is already doing it.",
               reframe: "Competition proves people will pay. Your culture, story and style can't be copied.",
               action: "Name one thing about you that no competitor has."),
        Belief(thought: "Nobody will pay for what I do.",
               reframe: "People already pay for braids, tutoring, food and kicks. Ask before you assume.",
               action: "Ask 3 people what they'd pay for your service."),
        Belief(thought: "I'm too young for this.",
               reframe: "Your age is an advantage. You know what your peers want and where they hang out.",
               action: "Find one need your friends have that no one is solving."),
        Belief(thought: "What if I fail?",
               reframe: "A test that doesn't work is data. Small experiments are cheap.",
               action: "Design a $10, one-weekend test of your idea.")
    ]
}
