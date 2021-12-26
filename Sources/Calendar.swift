import Foundation

extension Calendar {
    var trackingWeek: [Date] {
        (0 ..< 7)
            .map {
                Calendar.current.date(byAdding: .day, value: -$0, to: .now)!
            }
            .reversed()
    }
}
