import SwiftUI

struct Orb: Identifiable, Hashable {
    let id: String
    let label: String
    let symbol: String
}

enum Ring: CaseIterable, Identifiable {
    case skill, culture, people
    var id: Self { self }

    var title: String {
        switch self {
        case .skill: "Skills"
        case .culture: "Culture"
        case .people: "People"
        }
    }
    var color: Color {
        switch self {
        case .skill: .blue
        case .culture: .orange
        case .people: .green
        }
    }
    var orbs: [Orb] {
        switch self {
        case .skill: NicheData.skills
        case .culture: NicheData.cultures
        case .people: NicheData.people
        }
    }
}

struct Niche {
    let who: String
    let struggle: String
    let offering: String

    /// e.g. "Bilingual short-form videos for family-owned businesses"
    var title: String {
        offering.prefix(1).uppercased() + offering.dropFirst() + " for " + who
    }
    var sentence: String {
        "I help \(who) who are struggling with \(struggle) by offering \(offering)."
    }
}

enum NicheData {
    static let skills = [
        Orb(id: "video", label: "Video & photo", symbol: "camera.fill"),
        Orb(id: "cooking", label: "Cooking & baking", symbol: "fork.knife"),
        Orb(id: "hair", label: "Hair & beauty", symbol: "scissors"),
        Orb(id: "tutoring", label: "Tutoring", symbol: "book.fill"),
        Orb(id: "design", label: "Design & art", symbol: "paintbrush.fill")
    ]
    static let cultures = [
        Orb(id: "bilingual", label: "Bilingual", symbol: "character.bubble.fill"),
        Orb(id: "food", label: "Food traditions", symbol: "cup.and.saucer.fill"),
        Orb(id: "music", label: "Music", symbol: "music.note"),
        Orb(id: "neighborhood", label: "Neighborhood pride", symbol: "building.2.fill"),
        Orb(id: "family", label: "Family traditions", symbol: "heart.fill")
    ]
    static let people = [
        Orb(id: "business", label: "Family-owned businesses", symbol: "storefront.fill"),
        Orb(id: "college", label: "College students", symbol: "graduationcap.fill"),
        Orb(id: "parents", label: "Busy parents", symbol: "house.fill"),
        Orb(id: "community", label: "Community groups & nonprofits", symbol: "person.3.fill"),
        Orb(id: "artists", label: "Local artists & creators", symbol: "paintpalette.fill")
    ]

    // Who, in the same order as `people`.
    static let whoText = [
        "family-owned businesses", "college students", "busy parents",
        "community groups and nonprofits", "local artists and creators"
    ]

    // Offering: [skill][culture]
    static let offeringTable: [[String]] = [
        // Video & photo
        ["bilingual short-form videos", "recipe and kitchen-story videos",
         "music-driven reels and event highlights", "local-spotlight photo and video series",
         "family celebration and milestone photography"],
        // Cooking & baking
        ["bilingual cooking classes", "homemade family-recipe plates and desserts",
         "party platters and treats for music events", "neighborhood-style comfort food pop-ups",
         "family-recipe food orders for celebrations"],
        // Hair & beauty
        ["styling with bilingual service for the whole family",
         "natural hair and skin care made with traditional ingredients",
         "festival- and performance-ready styles", "mobile styling in the neighborhood",
         "braiding and styling for graduations, birthdays and family events"],
        // Tutoring
        ["bilingual tutoring that includes parents", "math and reading lessons built around cooking",
         "learning through music and rhythm", "low-cost neighborhood study groups",
         "homework sessions that involve the whole family"],
        // Design & art
        ["bilingual flyers, menus and logos", "logos and packaging for food businesses",
         "album art and event posters", "murals, stickers and local-pride merch",
         "custom invitations, cards and keepsakes"]
    ]

    // Struggle: [skill][people]
    static let struggleTable: [[String]] = [
        // Video & photo
        ["getting noticed on social media", "showing off their projects and clubs",
         "capturing memories when life is busy", "promoting events and boosting turnout",
         "reaching more people with their work"],
        // Cooking & baking
        ["adding new products without extra work", "finding cheap meals that taste like home",
         "finding time to cook", "feeding a crowd on a budget",
         "feeding guests at shows and events"],
        // Hair & beauty
        ["keeping a polished look on a busy schedule", "finding affordable styles that last",
         "booking stylists who can do kids and adults in one visit",
         "looking polished for fundraisers and events", "finding stylists for shoots and performances"],
        // Tutoring
        ["building English, math or computer skills", "falling behind in tough classes",
         "helping with homework", "running youth programs without enough volunteers",
         "learning pricing, taxes and business basics"],
        // Design & art
        ["looking professional with a logo and brand", "making standout posters for clubs and events",
         "finding personal gifts and party decor", "promoting events with eye-catching materials",
         "branding their art like a business"]
    ]

    static func make(skill: Orb, culture: Orb, person: Orb) -> Niche? {
        guard let s = skills.firstIndex(of: skill),
              let c = cultures.firstIndex(of: culture),
              let p = people.firstIndex(of: person) else { return nil }
        return Niche(who: whoText[p],
                     struggle: struggleTable[s][p],
                     offering: offeringTable[s][c])
    }
}
