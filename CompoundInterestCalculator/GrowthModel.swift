import Foundation
import Observation

struct YearPoint: Identifiable {
    let year: Int
    let contributed: Double
    let balance: Double
    var interest: Double { balance - contributed }
    var id: Int { year }
}

/// One stacked-bar slice, so Swift Charts can color by kind.
struct Segment: Identifiable {
    let year: Int
    let kind: String      // "You put in" or "Interest"
    let amount: Double
    var id: String { "\(year)-\(kind)" }
}

@Observable
final class GrowthModel {
    var startingMoney: Double = 5_000
    var monthlyContribution: Double = 300
    var annualRate: Double = 7        // percent
    var years: Double = 25

    /// Balance at the end of each year (monthly compounding,
    /// contribution added at the end of each month).
    var points: [YearPoint] {
        let r = annualRate / 100 / 12
        var balance = startingMoney
        var result: [YearPoint] = []
        let totalMonths = Int(years) * 12
        guard totalMonths > 0 else { return result }
        for month in 1...totalMonths {
            balance = balance * (1 + r) + monthlyContribution
            if month % 12 == 0 {
                result.append(YearPoint(
                    year: month / 12,
                    contributed: startingMoney + monthlyContribution * Double(month),
                    balance: balance))
            }
        }
        return result
    }

    var segments: [Segment] {
        points.flatMap {
            [Segment(year: $0.year, kind: "You put in", amount: $0.contributed),
             Segment(year: $0.year, kind: "Interest", amount: $0.interest)]
        }
    }

    var finalBalance: Double { points.last?.balance ?? startingMoney }
    var totalContributed: Double { points.last?.contributed ?? startingMoney }
    var totalInterest: Double { finalBalance - totalContributed }
    var multiple: Double { totalContributed > 0 ? finalBalance / totalContributed : 1 }
}
