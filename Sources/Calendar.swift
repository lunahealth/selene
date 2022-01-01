import Foundation

extension Calendar {
    static var global = current
    
    var today: UInt32 {
        .init(startOfDay(for: .now).timeIntervalSince1970 + offset)
    }
    
    var offset: TimeInterval {
        .init(timeZone.secondsFromGMT())
    }
    
    var trackingWeek: [Date] {
        (0 ..< 7)
            .map {
                date(byAdding: .day, value: -$0, to: .now)!
            }
            .reversed()
    }
    
    func isToday(journal: Journal) -> Bool {
        isDateInToday(.init(timeIntervalSince1970: .init(journal.timestamp) - offset))
    }
}
