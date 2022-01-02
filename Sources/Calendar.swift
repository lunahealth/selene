import Foundation

extension Calendar {
    static var global = current
    
    var today: UInt32 {
        .init(startOfDay(for: .now).timeIntervalSince1970 + offset)
    }
    
    var offset: TimeInterval {
        .init(timeZone.secondsFromGMT())
    }
    
    var week: [Date] {
        (0 ..< 7)
            .map {
                date(byAdding: .day, value: -$0, to: .now)!
            }
            .reversed()
    }
    
    func gmtDay(from date: Date) -> Date {
        .init(timeIntervalSince1970: date.timeIntervalSince1970 + offset)
    }
    
    func isSame(date: Date, as d: Date) -> Bool {
        isDate(.init(timeIntervalSince1970: date.timeIntervalSince1970 - offset),
               inSameDayAs: .init(timeIntervalSince1970: d.timeIntervalSince1970 - offset))
    }
}
